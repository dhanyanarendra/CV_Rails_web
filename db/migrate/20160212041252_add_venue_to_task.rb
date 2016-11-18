class AddVenueToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :venue, :string
  end
end
