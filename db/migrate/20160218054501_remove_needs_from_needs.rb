class RemoveNeedsFromNeeds < ActiveRecord::Migration
  def change
    remove_column :needs, :needs, :string
  end
end
