module Payouts
  class Base
    class Errors
      def on(*args)
      end
    end

    ACTIONS = [:add, :remove]

    cattr_accessor :types

    attr_accessor :value, :visible

    class << self
      def inherited(base)
        Payouts::Base.types ||= []
        Payouts::Base.types << base
      end

      def payout_name
        to_s.demodulize.underscore
      end

      def by_name(name)
        "Payouts::#{name.to_s.classify}".constantize
      end

      def human_attribute_name(field)
        I18n.t(field,
          :scope    => [:payouts, payout_name, :attributes],
          :default  => I18n.t(field,
            :scope    => [:payouts, :base, :attributes],
            :default  => field.humanize
          )
        )
      end
    end

    def initialize(attributes = {})
      attributes.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    def name
      self.class.payout_name
    end

    def apply(character, reference = nil)
      raise "Not implemented"
    end

    def applicable?(*triggers)
      (apply_on & triggers).present? && Dice.chance(chance, 100)
    end

    def errors
      Errors.new
    end

    def chance
      @chance ||= 100
    end

    def chance=(value)
      @chance = value.to_i
    end

    def apply_on
      if @apply_on.is_a?(Array)
        @apply_on
      elsif !@apply_on.nil?
        [@apply_on]
      else
        [:complete]
      end
    end

    def apply_on=(values)
      @apply_on = Array(values).collect{|value| value.to_sym }
    end

    def apply_on_label
      apply_on.collect{|value| value.to_s.humanize }.join(", ")
    end

    def action
      @action || :add
    end

    def action=(value)
      @action = value.to_sym
    end

    def visible=(value)
      if value == true || value == false
        @visible = value
      else
        @visible = (value.to_i != 0)
      end
    end

    def value=(value)
      @value = value.to_i
    end
  end
end
