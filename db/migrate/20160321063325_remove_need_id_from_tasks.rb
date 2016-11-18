class RemoveNeedIdFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :need_id, :integer
  end
end
