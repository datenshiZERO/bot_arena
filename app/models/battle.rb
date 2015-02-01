class Battle < ActiveRecord::Base
  belongs_to :arena
  has_many :unit_battle_outcomes
end
