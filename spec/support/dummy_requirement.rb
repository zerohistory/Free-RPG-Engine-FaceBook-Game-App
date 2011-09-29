class DummyRequirement < Requirements::Base
  attr_accessor :should_satisfy

  def satisfies?(character)
    should_satisfy
  end
end