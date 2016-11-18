class AddPriorityToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :priority, :boolean, default: false
  end
end
