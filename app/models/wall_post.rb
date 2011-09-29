class WallPost < ActiveRecord::Base
  PRIVACY_LEVEL = {
    :private  => 0,
    :alliance => 1,
    :public   => 2
  }

  cattr_reader :per_page
  @@per_page = 10

  default_scope :order => "wall_posts.created_at DESC"

  belongs_to :character
  belongs_to :author, :class_name => "Character"

  validates_presence_of :character, :author, :text
  validates_length_of :text, :maximum => 4.kilobytes

  attr_accessible :text

  def author_post?
    character == author
  end
end
