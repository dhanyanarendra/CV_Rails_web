class AddPledgedToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :pledged, :boolean
  end
end
