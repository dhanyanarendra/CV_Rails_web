class RemoveCreateprojectIdFromGoals < ActiveRecord::Migration
  def change
    remove_column :goals, :createproject_id, :integer
  end
end
