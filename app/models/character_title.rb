class CharacterTitle < ActiveRecord::Base
  belongs_to :character
  belongs_to :title
end
