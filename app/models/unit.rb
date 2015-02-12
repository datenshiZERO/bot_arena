class Unit < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit_template
  belongs_to :arena
  has_many :unit_battle_outcome

  #TODO limit to one weapon/armor/mobility
  has_many :user_equipments

  has_many :weapons, -> { where slot: "weapon" },
    through: :user_equipments, source: :equipment
  has_many :armors, -> { where slot: "armor" },
    through: :user_equipments, source: :equipment
  has_many :mobility_items, -> { where slot: "mobility" },
    through: :user_equipments, source: :equipment

end
