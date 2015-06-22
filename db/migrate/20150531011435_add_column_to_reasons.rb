class AddColumnToReasons < ActiveRecord::Migration
  def change
    add_column :reasons, :language, :string
  end
end
