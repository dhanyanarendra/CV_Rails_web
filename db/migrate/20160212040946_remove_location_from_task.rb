class RemoveLocationFromTask < ActiveRecord::Migration
  def change
    remove_column :tasks, :location, :point
  end
end
