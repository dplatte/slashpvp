class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :wins
      t.integer :losses
      t.integer :probability
      t.integer :team_composition_id
      t.datetime :last_played
      t.timestamps
    end
  end
end
