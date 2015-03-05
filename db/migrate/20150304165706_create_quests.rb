class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
      t.string :name
      t.text :description
      t.integer :stage
      t.integer :xp_win
      t.integer :credits_win
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
