module SettingSpecHelper
  def with_setting(values = {}, &block)
    old_values = {}
    
    values.each do |key, value|
      old_values[key] = Setting[key]
    
      Setting[key] = value
      Setting.update_cache!(true)
    end
    
    block.call
    
    values.each_key do |key|
      Setting[key] = old_values[key]
      Setting.update_cache!(true)
    end
  end
end