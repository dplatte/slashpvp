class CreateLadderRungs < ActiveRecord::Migration
  def change
    create_table :ladder_rungs do |t|
      t.integer :ranking
      t.integer :rating
      t.string :name
      t.string :realm_name
      t.integer :race_id
      t.integer :class_id
      t.integer :spec_id
      t.integer :faction_id
      t.integer :gender_id
      t.integer :season_wins
      t.integer :season_losses
      t.integer :weekly_wins
      t.integer :weekly_losses
      t.integer :region_id
      t.integer :bracket_id
      t.timestamps
    end
  end
end
