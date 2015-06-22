class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user
      t.string :who
      t.integer :refer
      t.string :url
      t.integer :status

      t.timestamps null: false
    end
  end
end
