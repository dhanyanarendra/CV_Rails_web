class AddAvatarToDescribes < ActiveRecord::Migration
  def change
    add_column :describes, :avatar, :string
  end
end
