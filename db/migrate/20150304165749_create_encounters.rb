class CreateEncounters < ActiveRecord::Migration
  def change
    create_table :encounters do |t|
      t.references :quest, index: true
      t.integer :wave, default: 1
      t.string :monster_slug
      t.integer :count, default: 1

      t.timestamps null: false
    end
    add_foreign_key :encounters, :quests
  end
end
