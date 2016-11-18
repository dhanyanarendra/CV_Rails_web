class RemoveLongDescriptionFromDescribes < ActiveRecord::Migration
  def change
    remove_column :describes, :long_description, :string
  end
end
