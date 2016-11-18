class RemoveFieldsFromDescribes < ActiveRecord::Migration
  def change
    remove_column :describes, :image, :string
    remove_column :describes, :avatar, :string
  end
end
