module Notification
  class Base < ActiveRecord::Base
    set_table_name :notifications

    belongs_to :character

    serialize :data

    state_machine :initial => :pending do
      state :displayed
      state :disabled

      event :schedule do
        transition :displayed => :pending
      end

      event :display do
        transition any => :displayed
      end

      event :disable do
        transition any => :disabled
      end
    end

    named_scope :by_type, Proc.new{|type|
      {
        :conditions => {:type => type_to_class_name(type)}
      }
    }

    named_scope :pending_by_type, Proc.new{|type|
      {
        :conditions => {
          :type   => type_to_class_name(type),
          :state  => "pending"
        }
      }
    }

    def self.type_to_class_name(type)
      "Notification::#{type.to_s.classify}"
    end

    def self.type_to_class(type)
      type_to_class_name(type).constantize
    end

    def class_to_type
      self.class.name.split("::").last.underscore.to_sym
    end
  end
end
