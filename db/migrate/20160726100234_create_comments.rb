class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment_body
      t.integer :user_id
      t.integer :describe_id

      t.timestamps null: false
    end
  end
end
