module Admin::TranslationsHelper
  def translation_id(key)
    key.gsub(/\./, "_")
  end
end
