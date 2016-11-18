class AddDescribeIdToTaskSuggestions < ActiveRecord::Migration
  def change
    add_column :task_suggestions, :describe_id, :integer
  end
end
