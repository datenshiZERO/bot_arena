class UnitTemplate < ActiveRecord::Base
  has_many :units
  belongs_to :weapon_default, 
    -> { where slot: "weapon" },
    foreign_key: 'weapon_default_id',
    class_name: 'Equipment'
  belongs_to :armor_default, 
    -> { where slot: "armor" },
    foreign_key: 'armor_default_id',
    class_name: 'Equipment'
  belongs_to :mobility_default,
    -> { where slot: "mobility" }, 
    foreign_key: 'mobility_default_id',
    class_name: 'Equipment'
  has_many :battle_bots
end
