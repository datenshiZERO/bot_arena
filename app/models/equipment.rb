class Equipment < ActiveRecord::Base
  has_many :user_equipments
  has_many :unit_templates

  SLOTS = ["weapon", "armor", "mobility"]
end
