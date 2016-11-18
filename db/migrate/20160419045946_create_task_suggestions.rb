class CreateTaskSuggestions < ActiveRecord::Migration
  def change
    create_table :task_suggestions do |t|
      t.string :suggestion_title
      t.date :date
      t.time :time
      t.string :description
      t.string :venue
      t.string :timezone
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
