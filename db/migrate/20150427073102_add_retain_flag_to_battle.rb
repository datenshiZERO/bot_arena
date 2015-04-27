class AddRetainFlagToBattle < ActiveRecord::Migration
  def change
    add_column :battles, :retain, :boolean, default: false, index: true
    remove_foreign_key "unit_battle_outcomes", "battles"
    add_foreign_key "unit_battle_outcomes", "battles", on_delete: :cascade
  end
end
