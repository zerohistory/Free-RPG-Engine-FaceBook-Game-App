module HasOwnership
  def self.included(base)
    base.has_many :ownerships, :as => :target, :dependent => :destroy do
      def character_types
        all(:include => :character_type).collect(&:character_type)
      end

      def character_type_ids
        all.collect(&:character_type_id)
      end
    end

    base.after_save :update_ownerships

    base.named_scope :owner_for, Proc.new {|character_or_type|
      case character_or_type
      when Character
        type_id = character_or_type.character_type.id
      when CharacterType
        type_id = character_or_type.id
      else
        raise "Wrong ownership filter type"
      end

      {
        :joins      => %{
          LEFT JOIN ownerships ON #{base.table_name}.id = ownerships.target_id
          AND ownerships.target_type = '#{base.name}'
        },
        :conditions => "ownerships.id IS NULL OR ownerships.character_type_id = #{type_id}"
      }
    }
  end

  def owner_type_ids
    @owner_type_ids || ownerships.owner_type_ids
  end

  def owner_type_ids=(values)
    @owner_type_ids = CharacterType.find_all_by_id(values).collect(&:id)
  end

  def update_ownerships
    if @owner_type_ids
      transaction do
        ownerships.delete_all

        @owner_type_ids.each do |id|
          ownerships.create!(:character_type_id => id)
        end
      end
    end
  end
end
