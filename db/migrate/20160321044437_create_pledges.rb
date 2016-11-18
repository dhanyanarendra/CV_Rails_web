class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.text  :pledge_content
      t.integer :user_contributor_id
      t.integer :need_id
      t.timestamps null: false
    end
  end
end
