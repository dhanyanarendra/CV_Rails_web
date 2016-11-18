class AddTaskIdToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :task_id, :integer
  end
end
