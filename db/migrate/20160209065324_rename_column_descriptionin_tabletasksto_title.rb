class RenameColumnDescriptioninTabletaskstoTitle < ActiveRecord::Migration
  def change
    rename_column :tasks, :description, :title
  end
end
