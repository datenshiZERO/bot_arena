class ModifyStartingMoney < ActiveRecord::Migration
  def change
    change_column :users, :credits, :integer, default: 200
  end
end
