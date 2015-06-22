class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :user
      t.string :name
      t.string :email
      t.string :img
      t.integer :status

      t.timestamps null: false
    end
  end
end
