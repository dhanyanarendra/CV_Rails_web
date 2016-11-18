class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :goal_id
      t.integer :need_id
      t.string :description

      t.timestamps null: false
    end
  end
end
