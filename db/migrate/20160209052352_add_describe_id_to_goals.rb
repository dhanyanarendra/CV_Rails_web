class AddDescribeIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :describe_id, :integer
  end
end
