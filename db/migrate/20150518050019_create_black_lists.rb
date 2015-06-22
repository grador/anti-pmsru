class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.integer :user, index:true
      t.string :email, index:true
      t.string :name
      t.string :ip, index:true
      t.integer :flag
      t.integer :status

      t.timestamps null: false
    end
  end
end
