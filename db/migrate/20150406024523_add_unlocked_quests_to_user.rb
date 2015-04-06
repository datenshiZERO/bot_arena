class AddUnlockedQuestsToUser < ActiveRecord::Migration
  def change
    add_column :users, :unlocked_quests, :string, default: "Y" + "N" * 99
  end
end
