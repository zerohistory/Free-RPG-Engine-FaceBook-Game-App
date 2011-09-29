class Character
  module Levels
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    DATA_FILE = Rails.root.join('db', 'data', 'experience.txt')
        
    EXPERIENCE = File.file?(DATA_FILE) ? File.read(DATA_FILE).split(/\s+/im).map{|v| v.strip.to_i } : []
    
    def experience_to_next_level
      next_level_experience - experience
    end

    def next_level_experience
      EXPERIENCE[level]
    end

    def level_progress_percentage
      (100 - experience_to_next_level.to_f / (next_level_experience - EXPERIENCE[level - 1]) * 100).round
    end
    
    def level_for_current_experience
      EXPERIENCE.count{|e| e <= experience}
    end
    
  end
end