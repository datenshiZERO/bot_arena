class AddMoreInfoToUnitBattleOutcomes < ActiveRecord::Migration
  def change
    add_column :unit_battle_outcomes, :assists, :integer, default: 0
  end
end
