class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true
      t.references :letter, index: true
      t.integer :status
      t.integer :event_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :histories, :users
    add_foreign_key :histories, :letters
  end
end
