class CreateGlyphs < ActiveRecord::Migration
  def change
    create_table :glyphs do |t|
      t.integer :glyph_id
      t.integer :item_id
      t.string :name
      t.string :icon
      t.integer :type_id
      t.references :character_class, index: true, foreign_key: true
      t.timestamps
    end
  end
end
