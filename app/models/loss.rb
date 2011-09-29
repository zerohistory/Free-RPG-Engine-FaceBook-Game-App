class Loss < ActiveRecord::Base
  belongs_to :item
  belongs_to :fight
end
