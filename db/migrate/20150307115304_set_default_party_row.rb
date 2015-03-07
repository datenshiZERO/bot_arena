class SetDefaultPartyRow < ActiveRecord::Migration
  def change
    change_column :raids, :unit_1_front, :boolean, default: true
    change_column :raids, :unit_2_front, :boolean, default: true
    change_column :raids, :unit_3_front, :boolean, default: true
    change_column :raids, :unit_4_front, :boolean, default: true
    change_column :raids, :unit_5_front, :boolean, default: true
    change_column :raids, :unit_6_front, :boolean, default: true
  end
end
