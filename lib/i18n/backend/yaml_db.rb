module I18n
  module Backend
    class YamlDb < Simple
      protected

      def init_translations
        super

        available_locales.each do |locale|
          store_translations(locale, Translation.to_hash)
        end
      end
    end
  end
end
