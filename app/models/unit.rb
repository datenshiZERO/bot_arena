class Unit < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit_template
  belongs_to :arena
  has_many :unit_battle_outcome
  has_many :user_equipments

  #TODO limit to one weapon/armor/mobility
end
