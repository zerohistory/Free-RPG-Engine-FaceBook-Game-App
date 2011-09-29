class Character
  module Titles
    def self.included(base)
      base.class_eval do
        has_many :character_titles
        has_many :titles, :through => :character_titles, :uniq => true
      end
    end
  end
end
