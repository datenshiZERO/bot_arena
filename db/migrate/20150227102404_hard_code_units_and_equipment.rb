class HardCodeUnitsAndEquipment < ActiveRecord::Migration
  def change
    remove_foreign_key :user_equipments, :equipment
    remove_index :user_equipments, :equipment_id
    remove_column :user_equipments, :equipment_id

    add_column :user_equipments, :equipment_slug, :string

    drop_table :equipment

    remove_foreign_key :battle_bots, :unit_templates
    remove_index :battle_bots, :unit_template_id
    remove_column :battle_bots, :unit_template_id
    add_column :battle_bots, :template_slug, :string

    remove_foreign_key :units, :unit_templates
    remove_index :units, :unit_template_id
    remove_column :units, :unit_template_id
    add_column :units, :template_slug, :string

    drop_table :unit_templates
  end
end
