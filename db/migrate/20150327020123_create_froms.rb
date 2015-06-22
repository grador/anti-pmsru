class CreateFroms < ActiveRecord::Migration
  def change
    create_table :froms do |t|
      t.integer :user
      t.string :name
      t.string :email
      t.integer :status

      t.timestamps null: false
    end
  end
end
