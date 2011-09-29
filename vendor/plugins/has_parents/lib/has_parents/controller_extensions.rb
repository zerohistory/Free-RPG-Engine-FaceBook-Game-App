module HasParents
  module ControllerExtensions
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)
      base.send(:helper_method, :parents, :last_parent, :has_parents?)
    end

    module ClassMethods
      attr_accessor_with_default :parent_keys, []

      def has_parents(*args)
        self.parent_keys = args.map(&:to_sym)
      end
    end

    module InstanceMethods
      # Protecting parent search methods from being called as controller actions
      protected
      
      def parent_keys
        return self.class.parent_keys unless self.class.parent_keys.empty?
        
        request.path_parameters.keys.map{|key|
          key.match(/^(.*)_id$/).to_a[1]
        }.compact
      end
      
      def parents
        return @_parent_objects unless @_parent_objects.nil?

        @_parent_objects = HasParents::ParentCollection.new

        parent_keys.each do |key|
          if parent = parent_by_key(key)
            @_parent_objects[key.to_sym] = parent
          end
        end

        @_parent_objects
      end

      def parent_by_key(key)
        begin
          klass = key.to_s.classify.constantize
          
          klass.respond_to?(:as_parent) ? klass.as_parent(params["#{key}_id"]).find(:first) : klass.find_by_id(params["#{key}_id"])
        rescue
        end
      end

      def has_parents?
        !parents.empty?
      end

      def last_parent
        parents.last
      end
    end
  end
end