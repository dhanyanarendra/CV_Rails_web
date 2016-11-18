class RemoveTaskeIdFromNeeds < ActiveRecord::Migration
  def change
    remove_column :needs, :taske_id, :integer
  end
end
