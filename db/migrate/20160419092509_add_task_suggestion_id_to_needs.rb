class AddTaskSuggestionIdToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :task_suggestion_id, :integer
  end
end
