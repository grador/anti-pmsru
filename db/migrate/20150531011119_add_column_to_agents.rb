class AddColumnToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :language, :string
  end
end
