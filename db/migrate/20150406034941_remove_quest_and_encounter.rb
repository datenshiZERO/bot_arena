class RemoveQuestAndEncounter < ActiveRecord::Migration
  def change
    remove_foreign_key "encounters", "quests"
    remove_foreign_key "raids", "quests"
    drop_table :encounters
    drop_table :quests
  end
end
