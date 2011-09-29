module Rails
  def self.restart!
    Rails.logger.debug "Restarting server..."

    FileUtils.mkdir_p Rails.root.join("tmp")

    FileUtils.touch Rails.root.join("tmp", "restart.txt")
  end
end
