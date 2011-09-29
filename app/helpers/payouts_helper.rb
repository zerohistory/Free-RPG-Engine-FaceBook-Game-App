module PayoutsHelper
  class ListBuilder
    attr_reader :template, :container, :payouts, :options

    delegate :capture, :render, :to => :template

    def initialize(template, container, payouts, options = {})
      @template = template
      @container = container
      @payouts = payouts
      @options = options.reverse_merge(
        :action => :add,
        :format => :result
      )
    end

    def applicable_payouts
      @applicable_payouts ||= payouts.by_action(options[:action]).reject{|payout|
        options[:format] == :preview && !payout.visible ||
        options[:triggers] && (options[:triggers] & payout.apply_on).empty?
      }
    end

    def payout_list
      result = ""

      applicable_payouts.each do |payout|
        result << render("payouts/#{options[:format]}/#{payout.class.payout_name}",
            :container  => container,
            :payout     => payout,
            :options    => options
          )
      end

      result.html_safe
    end

    def html(&block)
      if applicable_payouts.any?
        block_given? ? capture(self, &block) : payout_list
      end
    end
  end

  def payout_list(container, payouts, options = {}, &block)
    return unless payouts

    content = ListBuilder.new(self, container, payouts, options).html(&block)

    block_given? ? concat(content.to_s) : content.to_s
  end

  def payout(type, value, options = {}, &block)
    result = content_tag(options.delete(:tag) || :div,
      content_tag(:span, value, :class => :value) +
      (block_given? ? capture(&block) : "") +
      content_tag(:span, options.delete(:label) || Character.human_attribute_name(type.to_s), :class => :label),
      :class => "#{type} payout"
    )

    block_given? ? concat(result) : result
  end

  def payout_string(payouts, last_del)
    return unless payouts

    payouts_strings = []

    payouts.each do |payout|
      payouts_strings << render("payouts/news/#{payout.class.to_s.underscore.split("/").last}",
        :payout => payout)
    end

    result = case payouts_strings.size
      when 1
        payouts_strings[0]
      else
        [payouts_strings[0..-2], payouts_strings.last].join("#{last_del}&nbsp;")
      end

    result.html_safe
  end
end
