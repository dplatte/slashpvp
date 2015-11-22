class CreateRosterSlots < ActiveRecord::Migration
  def change
    create_table :roster_slots do |t|
      t.integer :team_id
      t.integer :character_id
      t.timestamps
    end
    add_index :roster_slots, :team_id
    add_index :roster_slots, :character_id
    add_index :roster_slots, [:team_id, :character_id], unique: true
  end
end
