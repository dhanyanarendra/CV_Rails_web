class AddQuantityToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :quantity, :string
    add_column :pledges, :unit, :string
  end
end
