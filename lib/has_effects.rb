module HasEffects
  def has_effects
    Dir[File.join(RAILS_ROOT, "app", "models", "effects", "*.rb")].each do |file|
      file.gsub(File.join(RAILS_ROOT, "app", "models"), "").gsub(".rb", "").classify.constantize
    end

    serialize :effects, Effects::Collection

    send(:include, InstanceMethods)
  end

  module InstanceMethods
    def effects
      super || Effects::Collection.new
    end

    def effects=(collection)
      if collection and !collection.is_a?(Effects::Collection)
        items = collection.values.collect do |effect|
          Effects::Base.by_name(effect[:type]).new(effect[:value])
        end

        collection = Effects::Collection.new(*items)
      end

      super(collection)
    end
  end
end
