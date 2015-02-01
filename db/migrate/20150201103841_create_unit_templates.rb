class CreateUnitTemplates < ActiveRecord::Migration
  def change
    create_table :unit_templates do |t|
      t.string :name
      t.string :slug
      t.integer :price, default: 0
      t.integer :kill_requirement, default: 0
      t.integer :mission_requirement, default: 0
      t.integer :hp, default: 1
      t.integer :evade, default: 10
      t.integer :move, default: 3
      t.integer :defense, default: 0
      t.integer :weapon_default_id
      t.integer :weapon_pt_limit, default: 1
      t.integer :armor_default_id
      t.integer :armor_pt_limit, default: 1
      t.integer :mobility_default_id
      t.integer :mobility_pt_limit, default: 1

      t.timestamps null: false
    end

    add_index :unit_templates, :name
    add_index :unit_templates, :slug, unique: true
    add_index :unit_templates, :weapon_default_id
    add_index :unit_templates, :armor_default_id
    add_index :unit_templates, :mobility_default_id
  end
end
