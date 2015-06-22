class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :user, index: true
      t.string :name
      t.string :img
      t.integer :cycle_day
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :friends, :users
  end
end
