class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user
      t.references :friend, index: true
      t.references :reason, index: true
      t.date :begin_date
      t.string :period
      t.integer :duration_day
      t.integer :shift_day
      t.integer :color
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :events, :friends
    add_foreign_key :events, :reasons
  end
end
