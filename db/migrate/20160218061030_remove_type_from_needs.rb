class RemoveTypeFromNeeds < ActiveRecord::Migration
  def change
    remove_column :needs, :type, :string
  end
end
