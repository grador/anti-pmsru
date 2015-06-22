class AddFieldToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :gender, :boolean
  end
end
