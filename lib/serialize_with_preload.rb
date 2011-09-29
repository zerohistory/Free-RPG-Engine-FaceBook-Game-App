module SerializeWithPreload
  def serialize(*args)
    Dir[File.join(RAILS_ROOT, "app", "models", "{effects,payouts,requirements}", "*.rb")].each do |file|
      file.gsub(File.join(RAILS_ROOT, "app", "models"), "").gsub(".rb", "").classify.constantize
    end

    super(*args)
  end
end
