class Character
  module SecretKeys
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def find_by_invitation_key(key)
        if character = find_by_id(key.split("-").first) and key.downcase == character.invitation_key
          character
        else
          nil
        end
      end

      def find_by_key(key)
        if character = find_by_id(key.split("-").first) and key.downcase == character.key
          character
        else
          nil
        end
      end
    end
    
    def invitation_key
      digest = Digest::MD5.hexdigest("%s-%s" % [created_at, id])

      "%s-%s" % [id, digest[0, 10]]
    end

    def key
      digest = Digest::MD5.hexdigest("%s-%s" % [id, created_at])

      "%s-%s" % [id, digest[0, 10]]
    end
  end
end