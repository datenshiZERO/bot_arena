class AddIconsToItemsAndUnits < ActiveRecord::Migration
  def change
    add_column :unit_templates, :icon_class, :string
    add_column :equipment, :icon_class, :string
  end
end
