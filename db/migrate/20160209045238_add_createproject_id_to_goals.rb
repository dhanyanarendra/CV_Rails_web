class AddCreateprojectIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :createproject_id, :integer
  end
end
