class CreateNeedComments < ActiveRecord::Migration
  def change
    create_table :need_comments do |t|
      t.text :body_description
      t.integer :user_id
      t.integer :need_id

      t.timestamps null: false
    end
  end
end
