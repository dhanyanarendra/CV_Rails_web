class AddTaskSuggestionIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_suggestion_id, :integer
  end
end
