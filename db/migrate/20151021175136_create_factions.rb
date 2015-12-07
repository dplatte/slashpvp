class CreateFactions < ActiveRecord::Migration
  def change
    create_table(:factions, :id => false) do |t|
      t.integer :id, :options => 'PRIMARY KEY'
      t.string :name
      t.timestamps
    end
  end
end
