class PublishedToDescribes < ActiveRecord::Migration
  def change
    add_column :describes, :published, :boolean, default: false
  end
end
