module HasParents
  class ParentCollection < ActiveSupport::OrderedHash
    def last
      self.values.last
    end

    def method_missing(name)
      return self[name]
    end
  end
end