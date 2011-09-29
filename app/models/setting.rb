class Setting < ActiveRecord::Base
  extend HasPayouts
  has_payouts

  validates_presence_of   :alias
  validates_uniqueness_of :alias

  before_save :serialize_payouts

  after_save :update_cache!

  cattr_accessor :cache

  class << self
    def update_cache!(force = false)
      if force || cache.nil? || (cache[:updated_at] < 5.seconds.ago && cache[:key] < Setting.maximum(:updated_at))
        self.cache = {
          :key => Setting.maximum(:updated_at),
          :values => Hash[all.map{|s| [s.alias.to_sym, s.value]}],
          :updated_at => Time.now
        }
      else
        cache[:updated_at] = Time.now if cache[:updated_at] < 5.seconds.ago
      end

      cache
    end

    # Returns value casted to integer
    def i(key)
      update_cache!

      cache[:values][key.to_sym].to_i
    end

    # Returns value casted to string
    def s(key)
      update_cache!

      cache[:values][key.to_sym].to_s
    end

    # Returns value casted to float
    def f(key)
      update_cache!

      cache[:values][key.to_sym].to_f
    end

    # Returns value casted to boolean
    def b(key)
      update_cache!

      value = cache[:values][key.to_sym].to_s.downcase

      %w{true yes 1}.include?(value) ? true : false
    end

    # Returns value casted to string array (splits string value by comma)
    def a(key)
      update_cache!

      cache[:values][key.to_sym].to_s.split(/\s*,\s*/)
    end

    # Returns percentage value casted to float
    def p(key, value_to_cast)
      update_cache!

      value_to_cast * cache[:values][key.to_sym].to_i * 0.01
    end

    def time(key)
      update_cache!

      if value = cache[:values][key.to_sym]
        ActiveSupport::TimeZone["UTC"].parse(value)
      else
        ActiveSupport::TimeZone["UTC"].at(0)
      end
    end

    def []=(key, value)
      if value.is_a?(Time)
        value = value.utc
      end

      if value.nil?
        find_by_alias(key.to_s).try(:destroy)
      elsif existing = find_by_alias(key.to_s)
        existing.update_attributes(:value => value)
      else
        create(:alias => key.to_s, :value => value)
      end

      update_cache!(true)
    end

    def [](key)
      find_by_alias(key.to_s).try(:value)
    end
  end

  def payout?
    self.alias.match(/_payout$/) ? true : false
  end

  def payouts
    @payouts ||= deserialize_payouts
  end

  protected

  def serialize_payouts
    if payout?
      self.value = YAML.dump(payouts)
    end
  end

  def deserialize_payouts
    if self.value
      YAML.load(value)
    else
      Payouts::Collection.new
    end
  end

  def update_cache!
    self.class.update_cache!(true)
  end
end
