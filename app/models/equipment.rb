class Equipment < ActiveRecord::Base
  has_many :user_equipments

  SLOTS = ["weapon", "armor", "mobility"]
end
