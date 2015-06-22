class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :cycle_day, :integer
    add_column :users, :begin, :date
  end
end
