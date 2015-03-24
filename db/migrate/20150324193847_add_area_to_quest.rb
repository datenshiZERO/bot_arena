class AddAreaToQuest < ActiveRecord::Migration
  def change
    add_column :quests, :area_id, :integer, default: 0
  end
end
