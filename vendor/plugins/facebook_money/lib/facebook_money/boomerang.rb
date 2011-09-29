module FacebookMoney
  module Boomerang
    extend self
    
    def valid_request?(params)
      params[:sig] == Digest::MD5.hexdigest("uid=#{params[:uid]}currency=#{params[:currency]}type=#{params[:type]}ref=#{params[:ref]}#{FacebookMoney.config["secret"]}")
    end

    def user_id(params)
      params[:uid]
    end

    def amount(params)
      params[:currency].to_i
    end

    def html_code(template, recipient_id, options = {})
      default_options = {
        :src => "http://boomapi.com/api/?key=%s&uid=%s&widget=%s" % [
          FacebookMoney.config["key"],
          recipient_id,
          FacebookMoney.config["widget"] || "w1"
        ],
        :frameborder  => 0,
        :width        => 760,
        :height       => 1750
      }

      template.content_tag("iframe", "", default_options.merge(options))
    end

    def success_response
      {:text => "OK"}
    end

    def failure_response
      {:text => "ERROR"}
    end
  end
end