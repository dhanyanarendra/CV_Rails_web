class AddNeedTypeToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :need_type, :string
  end
end
