module Paperclip
  module RemovableAttachment
    def has_attached_file(name, options = {})
      super(name, options.except(:removable))
        
      if options[:removable]
        attr_accessor "remove_#{name}".to_sym
        
        before_validation do |record|
          if record.send("#{name}?") and (record.send("remove_#{name}") == true or record.send("remove_#{name}") == "1")
            record.send("#{name}=", nil)
          end
        end
      end
    end
  end
end