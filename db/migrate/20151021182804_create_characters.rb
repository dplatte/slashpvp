class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :name
      t.references :realm, index: true, foreign_key: true
      t.references :character_race, index: true, foreign_key: true
      t.references :character_class, index: true , foreign_key: true
      t.references :character_spec, index: true, foreign_key: true
      t.references :faction, index: true, foreign_key: true
      t.references :gender, index: true, foreign_key: true
      t.timestamps
    end
  end
end
