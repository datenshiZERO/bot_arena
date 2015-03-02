class RemoveSlugFromUnit < ActiveRecord::Migration
  def change
    remove_column :units, :slug
  end
end
