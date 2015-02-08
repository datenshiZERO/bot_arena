class AddActiveFlag < ActiveRecord::Migration
  def change
    add_column :arenas, :active, :boolean, default: false
    add_column :equipment, :active, :boolean, default: false
    add_column :unit_templates, :active, :boolean, default: false
    add_index :arenas, :active
    add_index :equipment, :active
    add_index :unit_templates, :active
  end
end
