class AddCompletedQuestsToUser < ActiveRecord::Migration
  def change
    add_column :users, :completed_quests, :string, default: "N" * 100
  end
end
