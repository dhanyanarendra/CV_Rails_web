class AddLocationToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :location, :point, :geographic => true
  end
end
