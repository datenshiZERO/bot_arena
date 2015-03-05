class CreateRaids < ActiveRecord::Migration
  def change
    create_table :raids do |t|
      t.references :user, index: true
      t.references :quest, index: true
      t.integer :unit_1_id
      t.boolean :unit_1_front, default: false
      t.integer :unit_2_id
      t.boolean :unit_2_front, default: false
      t.integer :unit_3_id
      t.boolean :unit_3_front, default: false
      t.integer :unit_4_id
      t.boolean :unit_4_front, default: false
      t.integer :unit_5_id
      t.boolean :unit_5_front, default: false
      t.integer :unit_6_id
      t.boolean :unit_6_front, default: false
      t.integer :xp, default: 0
      t.integer :credits, default: 0
      t.integer :kills, default: 0
      t.text :raid_log
      t.string :outcome

      t.timestamps null: false
    end
    add_foreign_key :raids, :users
    add_foreign_key :raids, :quests
  end
end
