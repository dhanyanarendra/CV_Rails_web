class AddLikeCountToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :like_count, :integer
  end
end
