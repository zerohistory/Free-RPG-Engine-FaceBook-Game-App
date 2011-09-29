require "digest/md5"

module FacebookMoney
  class << self
    def config
      @@config ||= YAML.load_file(File.join(RAILS_ROOT, "config", "facebook_money.yml"))

      return @@config[RAILS_ENV || "development"]
    end

    def provider
      @@provider ||= "FacebookMoney::#{ config["provider"].classify }".constantize
    end
  end

  module ControllerMethods
    def on_valid_facebook_money_request
      if FacebookMoney.provider.valid_request?(params)
        yield(FacebookMoney.provider.user_id(params), FacebookMoney.provider.amount(params))
        
        render FacebookMoney.provider.success_response
      else
        render FacebookMoney.provider.failure_response
      end
    end
  end

  module HelperMethods
    def facebook_money(recipient, options = {})
      recipient_id = recipient.is_a?(Numeric) ? recipient : recipient.id

      FacebookMoney.provider.html_code(self, recipient_id, options)
    end
  end
end