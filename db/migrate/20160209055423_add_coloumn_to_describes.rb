class AddColoumnToDescribes < ActiveRecord::Migration
  def change
    add_column :describes, :type, :string
    add_column :describes, :name, :string
    add_column :describes, :file, :string
  end
end
