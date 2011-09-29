module HasRequirements
  def has_requirements
    Dir[File.join(RAILS_ROOT, "app", "models", "requirements", "*.rb")].each do |file|
      file.gsub(File.join(RAILS_ROOT, "app", "models"), "").gsub(".rb", "").classify.constantize
    end

    serialize :requirements, Requirements::Collection

    send(:include, InstanceMethods)
  end

  module InstanceMethods
    def requirements
      super || Requirements::Collection.new
    end

    def requirements=(collection)
      super(Requirements::Collection.parse(collection))
    end
  end
end
