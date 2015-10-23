class CreateCharacterRaces < ActiveRecord::Migration
  def change
    create_table :character_races do |t|
      t.integer :mask
      t.string :faction
      t.string :name
      t.timestamps
    end
  end
end
