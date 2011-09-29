module HasPayouts
  def has_payouts(*args)
    preload_payouts!

    options = args.extract_options!

    options.reverse_merge!(
      :apply_on => args.first
    )
    
    args.flatten!

    cattr_accessor :payout_events
    self.payout_events  = args

    cattr_accessor :payout_options
    self.payout_options = options

    if respond_to?(:serialize) and column_names.include?("payouts")
      serialize :payouts, Payouts::Collection

      send(:include, ActiveRecordMethods)
    else
      send(:include, NonActiveRecordMethods)
    end
  end

  def payout_events_for_select
    payout_events.collect{|event| [event.to_s.humanize, event]}
  end

  def preload_payouts!
    Dir[File.join(RAILS_ROOT, "app", "models", "payouts", "*.rb")].each do |file|
      file.gsub(File.join(RAILS_ROOT, "app", "models"), "").gsub(".rb", "").classify.constantize
    end
  end

  module ActiveRecordMethods
    def payouts
      super || Payouts::Collection.new
    end

    def payouts=(collection)
      super(Payouts::Collection.parse(collection))
    end
  end

  module NonActiveRecordMethods
    def payouts
      @payouts || Payouts::Collection.new
    end

    def payouts=(collection)
      @payouts = Payouts::Collection.parse(collection)
    end

    def payouts?
      payouts.any?
    end
  end
end
