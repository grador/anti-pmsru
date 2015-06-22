class AddColumnToFroms < ActiveRecord::Migration
  def change
    add_column :froms, :language, :string
  end
end
