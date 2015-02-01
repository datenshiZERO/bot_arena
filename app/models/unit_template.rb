class UnitTemplate < ActiveRecord::Base
  has_many :units
  belongs_to :weapon_default, 
    -> { where slot: "weapon" },
    class_name: 'Equipment'
  belongs_to :armor_default, 
    -> { where slot: "armor" },
    class_name: 'Equipment'
  belongs_to :mobility_default,
    -> { where slot: "mobility" }, 
    class_name: 'Equipment'
  has_many :battle_bots
end
