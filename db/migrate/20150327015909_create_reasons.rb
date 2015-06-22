class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.integer :user
      t.string :name
      t.string :period
      t.integer :duration_day
      t.integer :status

      t.timestamps null: false
    end
  end
end
