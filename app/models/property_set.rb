class PropertySet < ActiveRecord::Base
  validates_presence_of :name

  validate :check_property_presence

  def property_ids=(value)
    @properties = nil
    self[:property_ids] = value
  end

  def properties
    unless @properties
      if self[:property_ids].blank?
        @properties = []
      else
        @properties = JSON.parse(self[:property_ids]).collect do |property_id, frequency|
          if property = PropertyType.find_by_id(property_id)
            [property, frequency]
          else
            nil
          end
        end

        @properties.compact!
      end
    end

    @properties
  end

  def properties=(value)
    if value.is_a?(Hash)
      self.property_ids = value.values.collect{|params|
        params = params.symbolize_keys

        [params[:property_id].to_i, params[:frequency].to_i]
      }.to_json
    elsif value.is_a?(Array)
      self.property_ids = value.collect{|property_or_id, frequency|
        [
          property_or_id.is_a?(Item) ? property_or_id.id : property_or_id.to_i,
          frequency.to_i
        ]
      }.to_json
    elsif value.nil?
      self.property_ids = nil
    else
      raise ArgumentError
    end

    value
  end

  def random_property(shift = 0)
    if properties.empty?
      raise Exception.new('Item list is empty')
    else
      frequencies = properties.collect{|i| i.last }
      
      frequencies = frequencies.inject([]){|r, f| r.push((r.last || 0) + f * 100); r }
      max = frequencies.max
      chance = rand(max)
      result = frequencies.index{|f| chance < f } || 0

      # Shifting result position
      result = (result + shift) % frequencies.size

      properties[result][0]
    end
  end

  def size
    properties.size
  end

  protected

  def check_property_presence
    errors.add(:properties, :not_enough_properties) if properties.empty?
  end
end
