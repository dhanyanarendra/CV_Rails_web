class AddCheckedToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :checked, :boolean, default: false
  end
end
