class ApplicationController
  module ReferenceCode
    def self.included(base)
      base.helper_method(:encryptor, :reference_code)
    end

    protected

    def encryptor
      @reference_encoder ||= ActiveSupport::MessageEncryptor.new(Facebooker2.secret)
    end

    def reference_code(*args)
      options   = args.extract_options!
      reference = args.shift
      user_id   = args.shift || current_user.try(:id)
      
      encryptor.encrypt([reference, user_id, options].to_json)
    end
    
    def reference_data
      @reference_data ||= decrypt_reference_code(params[:reference_code]) if params[:reference_code]
    end

    def decrypt_reference_code(code)
      JSON.parse(encryptor.decrypt(code.to_s))
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      Rails.logger.error "Failed to decrypt reference code: #{code}"

      nil
    end
  end
end