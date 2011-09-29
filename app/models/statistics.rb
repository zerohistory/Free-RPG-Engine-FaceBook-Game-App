class Statistics
  def initialize(time_range)
    if time_range.is_a?(Range)
      @time_range = time_range
    else
      @time_range = (time_range .. Time.now)
    end
  end
end
