class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user
      t.string :theme
      t.string :text
      t.integer :status

      t.timestamps null: false
    end
  end
end
