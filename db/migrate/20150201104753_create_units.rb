class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.string :slug
      t.references :user, index: true
      t.references :unit_template, index: true
      t.references :arena, index: true
      t.string :attack_strategy
      t.string :move_strategy
      t.integer :xp, default: 0
      t.integer :kills, default: 0
      t.integer :missions, default: 0

      t.timestamps null: false
    end
    add_foreign_key :units, :users
    add_foreign_key :units, :unit_templates
    add_foreign_key :units, :arenas
  end
end
