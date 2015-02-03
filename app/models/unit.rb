class Unit < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit_template
  belongs_to :arena
  has_many :unit_battle_outcome

  #TODO limit to one weapon/armor/mobility
  has_many :user_equipments

  has_one :weapon, -> { where slot: "weapon" },
    through: :user_equipments, class_name: "Equipment"
  has_one :armor, -> { where slot: "armor" },
    through: :user_equipments, class_name: "Equipment"
  has_one :mobility, -> { where slot: "mobility" },
    through: :user_equipments, class_name: "Equipment"

end
