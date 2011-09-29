module Requirements
  class Alliance < Base
    def satisfies?(character)
      character.relations.effective_size >= @value
    end
  end
end
