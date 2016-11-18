class RemoveTypeFromDescribes < ActiveRecord::Migration
  def change
    remove_column :describes, :type, :string
  end
end
