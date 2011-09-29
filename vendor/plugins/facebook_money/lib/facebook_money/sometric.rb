module FacebookMoney
  module Sometric
    extend self
    
    def valid_request?(params)
      params[:txn_sig] == Digest::MD5.hexdigest("#{params[:uid]}#{params[:txn_value]}#{FacebookMoney.config["secret"]}#{params[:txn_date]}")
    end

    def user_id(params)
      params[:uid]
    end

    def amount(params)
      params[:txn_value].to_i
    end

    def html_code(template, recipient_id, options = {})
      default_options = {
        :src => "http://v.sometrics.com/vc_delivery.html?zid=%s&uid=%s&pid=%s" % [
          FacebookMoney.config["zid"],
          recipient_id,
          FacebookMoney.config["pid"]
        ],
        :frameborder  => 0,
        :width        => 600,
        :height       => 2400
      }

      template.content_tag("iframe", "", default_options.merge(options))
    end

    def success_response
      {:text => "1"}
    end

    def failure_response
      {:text => "0"}
    end
  end
end