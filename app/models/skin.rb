class Skin < ActiveRecord::Base
  state_machine :initial => :inactive do
    state :inactive
    state :active

    event :activate do
      transition :inactive => :active
    end

    event :deactivate do
      transition :active => :inactive
    end

    before_transition any => :active do
      Skin.with_state(:active).first.try(:deactivate)
    end
  end

  validates_presence_of :name
  validates_uniqueness_of :name

  class << self
    def update_sass
      all.each do |skin|
        skin.send(:update_sass)
      end
    end
  end

  protected

  def update_sass
    default_skin = File.read(Rails.root.join("public", "stylesheets", "sass", "application.sass"))

    default_skin.gsub!(/^\/\/\s*<--\s*Skin.*$/i, content)

    FileUtils.mkdir_p(File.dirname(sass_path))

    File.open(sass_path, "w+") do |file|
      file << default_skin
    end
  end

  def sass_path
    Rails.root.join("public", "stylesheets", "sass", "skins", "#{name.parameterize}.sass")
  end
end
