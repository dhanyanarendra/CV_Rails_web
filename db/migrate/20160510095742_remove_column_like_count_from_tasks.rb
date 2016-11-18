class RemoveColumnLikeCountFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :like_count, :integer
  end
end
