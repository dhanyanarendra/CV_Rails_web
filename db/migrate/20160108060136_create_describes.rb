class CreateDescribes < ActiveRecord::Migration
  def change
    create_table :describes do |t|
      t.text :title
      t.string :image
      t.string :category
      t.text :short_description
      t.text :long_description
      t.text :background
      t.text :impact
      t.text :need
      t.text :risks
      t.text :others

      t.timestamps null: false
    end
  end
end
