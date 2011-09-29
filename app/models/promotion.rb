class Promotion < ActiveRecord::Base
  extend HasPayouts

  has_many :promotion_receipts, :dependent => :delete_all

  has_payouts :success

  validates_presence_of :text, :valid_till

  def name
    "%s #%d" % [self.class.human_name, id]
  end

  def to_param
    "%s-%s" % [id, secret]
  end

  def secret
    Digest::MD5.hexdigest("%s-%s" % [id, created_at])[0..5]
  end

  def expired?
    Time.now > valid_till
  end

  def can_be_received?(character, secret)
    (secret == self.secret) &&
    !expired? &&
    promotion_receipts.find_by_character_id(character.id).nil?
  end
end
