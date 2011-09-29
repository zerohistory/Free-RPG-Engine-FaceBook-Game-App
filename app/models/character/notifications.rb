class Character
  module Notifications
    def self.included(base)
      base.class_eval do
        has_many :notifications,
          :class_name => "Notification::Base",
          :extend     => AssociationExtension
      end
    end

    module AssociationExtension
      def schedule(type, data = nil)
        if existing = by_type(type).first
          existing.transaction do
            existing.update_attributes(:data => data)

            existing.schedule if existing.displayed?
          end
        else
          klass = Notification::Base.type_to_class(type)

          self << klass.new(:data => data)
        end
      end
    end
  end
end
