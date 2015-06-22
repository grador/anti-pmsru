class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.integer :user
      t.references :event, index: true
      t.references :from, index: true
      t.references :message, index: true
      t.integer :agent, index: true
      t.integer :status

      t.timestamps null: false
    end
    add_foreign_key :letters, :events
    add_foreign_key :letters, :froms
    add_foreign_key :letters, :messages
  end
end
