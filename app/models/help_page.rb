class HelpPage < ActiveRecord::Base
  state_machine :initial => :hidden do
    state :hidden
    state :visible
    state :deleted

    event :publish do
      transition :hidden => :visible
    end

    event :hide do
      transition :visible => :hidden
    end

    event :mark_deleted do
      transition(any - [:deleted] => :deleted)
    end

    after_transition :do => :restart_server
  end

  validates_presence_of   :alias, :name
  validates_uniqueness_of :alias, :allow_blank => true
  validates_format_of     :alias, :with => /^[a-z\-_0-9]+$/i, :allow_blank => true

  before_save :process_content, :if => :content_changed?

  def self.visible?(key)
    @@keys ||= with_state(:visible).all(:select => "alias").collect{|p| p.alias }

    @@keys.include?(key.to_s)
  end

  protected

  def process_content
    self.content_processed = RedCloth.new(content).to_html
  end

  private

  def restart_server
    Rails.restart!
  end
end
