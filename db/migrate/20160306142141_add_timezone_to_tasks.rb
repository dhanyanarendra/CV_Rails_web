class AddTimezoneToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :timezone, :string
  end
end
