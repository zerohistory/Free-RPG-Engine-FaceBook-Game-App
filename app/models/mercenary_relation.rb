class MercenaryRelation < Relation
  before_create :copy_owner_attributes

  def self.random_name
    @@names     ||= File.read(File.join(Rails.root, "db", "data", "names.txt")).split("\n")
    @@surnames  ||= File.read(File.join(Rails.root, "db", "data", "surnames.txt")).split("\n")

    name = @@names[rand(@@names.size)].capitalize
    surname = @@surnames[rand(@@surnames.size)].capitalize

    "#{name} #{surname}"
  end

  protected

  def copy_owner_attributes
    self.name = self.class.random_name

    %w{level attack defence health energy stamina}.each do |attribute|
      self[attribute] = owner.send(attribute)
    end
  end
end
