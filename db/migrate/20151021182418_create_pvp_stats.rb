class CreatePvpStats < ActiveRecord::Migration
  def change
    create_table :pvp_stats do |t|
      t.integer :ranking
      t.integer :rating
      t.integer :season_wins
      t.integer :season_losses
      t.integer :weekly_wins
      t.integer :weekly_losses
      t.references :brackets, index: true, foreign_key: true
      t.belongs_to :character, index:true
      t.timestamps
    end
  end
end
