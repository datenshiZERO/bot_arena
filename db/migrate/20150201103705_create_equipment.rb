class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :name
      t.string :slug
      t.string :slot
      t.integer :accuracy
      t.integer :damage
      t.integer :range_min
      t.integer :range_max
      t.integer :bonus_hp, default: 0
      t.integer :bonus_evade, default: 0
      t.integer :bonus_move, default: 0
      t.integer :bonus_defense, default: 0
      t.integer :bonus_accuracy, default: 0
      t.integer :price, default: 0
      t.integer :points, default: 1
      t.integer :kill_requirement, default: 0
      t.integer :mission_requirement, default: 0

      t.timestamps null: false
    end

    add_index :equipment, :name
    add_index :equipment, :slug, unique: true
  end
end
