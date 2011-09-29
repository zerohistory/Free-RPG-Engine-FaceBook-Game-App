module HasVisibility
  def self.included(base)
    base.has_many :visibilities, :as => :target, :dependent => :destroy do
      def character_types
        all(:include => :character_type).collect(&:character_type)
      end

      def character_type_ids
        all.collect(&:character_type_id)
      end
    end

    base.after_save :update_visibilities

    base.named_scope :visible_for, Proc.new {|character_or_type|
      case character_or_type
      when Character
        type_id = character_or_type.character_type.id
      when CharacterType
        type_id = character_or_type.id
      else
        raise "Wrong visibility filter type"
      end

      {
        :joins      => %{
          LEFT JOIN visibilities ON #{base.table_name}.id = visibilities.target_id
          AND visibilities.target_type = '#{base.name}'
        },
        :conditions => "visibilities.id IS NULL OR visibilities.character_type_id = #{type_id}"
      }
    }
  end

  def visible_type_ids
    @visible_type_ids || visibilities.character_type_ids
  end

  def visible_type_ids=(values)
    @visible_type_ids = CharacterType.find_all_by_id(values).collect(&:id)
  end

  def update_visibilities
    if @visible_type_ids
      transaction do
        visibilities.delete_all

        @visible_type_ids.each do |id|
          visibilities.create!(:character_type_id => id)
        end
      end
    end
  end
end
