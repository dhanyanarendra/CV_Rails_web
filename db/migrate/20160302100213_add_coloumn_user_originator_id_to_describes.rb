class AddColoumnUserOriginatorIdToDescribes < ActiveRecord::Migration
  def change
    add_column :describes, :user_originator_id, :integer
  end
end
