module FacebookMoney
  module Gambit
    extend self
    
    def valid_request?(params)
      params[:sig] == Digest::MD5.hexdigest([params[:uid], params[:amount], params[:time], params[:oid], FacebookMoney.config["secret"]].join(""))
    end

    def user_id(params)
      params[:uid]
    end

    def amount(params)
      params[:amount].to_i
    end

    def html_code(template, recipient_id, options = {})
      default_options = {
        :src          => "http://getgambit.com/panel?k=%s&uid=%s" % [
          FacebookMoney.config["key"],
          recipient_id
        ],
        :frameborder  => 0,
        :width        => 630,
        :height       => 1750
      }

      template.content_tag("iframe", "", default_options.merge(options))
    end

    def success_response
      {:text => "OK"}
    end

    def failure_response
      {:text => "ERROR:FATAL"}
    end
  end
end