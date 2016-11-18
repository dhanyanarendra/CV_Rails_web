class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :type
      t.string :needs
      t.string :quantity
      t.string :unit
      t.integer :taske_id
      t.string :need_decription

      t.timestamps null: false
    end
  end
end
