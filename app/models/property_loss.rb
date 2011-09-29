class PropertyLoss < ActiveRecord::Base
  belongs_to :fight
  belongs_to :property_type
end
