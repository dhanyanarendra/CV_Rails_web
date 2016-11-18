class AddNeedNameToNeed < ActiveRecord::Migration
  def change
    add_column :needs, :need_name, :string
  end
end
