class CreateUnitBattleOutcomes < ActiveRecord::Migration
  def change
    create_table :unit_battle_outcomes do |t|
      t.references :battle, index: true
      t.references :unit, index: true
      t.string :outcome
      t.integer :xp, default: 0
      t.integer :credits, default: 0
      t.integer :kills, default: 0
      t.text :details

      t.timestamps null: false
    end
    add_foreign_key :unit_battle_outcomes, :battles
    add_foreign_key :unit_battle_outcomes, :units
  end
end
