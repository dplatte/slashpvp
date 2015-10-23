class CreateLadderStandings < ActiveRecord::Migration
  def change
    create_table :ladder_standings do |t|
      t.integer :rank
      t.integer :rating
      t.references :bracket, index: true
      t.references :region, index: true
      t.references :character, index: true
      t.timestamps
    end
  end
end
