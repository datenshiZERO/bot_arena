class AddMoreDetailsToUnitBattleOutcome < ActiveRecord::Migration
  def change
    add_column :unit_battle_outcomes, :team, :string
    add_column :battles, :winning_team, :string
  end
end
