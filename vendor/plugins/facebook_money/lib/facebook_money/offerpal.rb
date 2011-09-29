module FacebookMoney
  module Offerpal
    extend self
    
    def valid_request?(params)
      params[:verifier] == Digest::MD5.hexdigest([params[:id], params[:snuid], params[:currency], FacebookMoney.config["secret"]].join(":"))
    end

    def user_id(params)
      params[:snuid]
    end

    def amount(params)
      params[:currency].to_i
    end

    def html_code(template, recipient_id, options = {})
      default_options = {
        :src          => "http://pub.myofferpal.com/%s/showoffers.action?snuid=%s" % [
          FacebookMoney.config["application_id"],
          recipient_id
        ],
        :frameborder  => 0,
        :width        => 728,
        :height       => 2700,
        :scrolling    => :no
      }

      template.content_tag("iframe", "", default_options.merge(options))
    end

    def success_response
      {:text => "SUCCESS"}
    end

    def failure_response
      {:text => "ERROR", :status => 403}
    end
  end
end