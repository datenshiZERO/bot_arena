class LowerInitialMoney < ActiveRecord::Migration
  def change
    change_column :users, :credits, :integer, default: 150
  end
end
