class AddSuggestionStatusToTaskSuggestions < ActiveRecord::Migration
  def change
    add_column :task_suggestions, :suggestion_status, :boolean, default: false
  end
end
