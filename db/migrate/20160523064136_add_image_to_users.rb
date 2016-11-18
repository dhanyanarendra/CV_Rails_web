class AddImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :file, :string
    add_column :users, :name, :string
  end
end
