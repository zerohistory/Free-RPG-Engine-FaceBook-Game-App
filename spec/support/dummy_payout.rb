class DummyPayout < Payouts::Base
  attr_accessor :name
  attr_reader :applied, :character, :reference
  
  def apply(character, reference = nil)
    @applied = true
    @character = character
    @reference = reference
  end

  def applied?
    @applied
  end
end