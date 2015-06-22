class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :boolean
    add_column :users, :status, :integer
    add_column :users, :paid, :date
  end
end
