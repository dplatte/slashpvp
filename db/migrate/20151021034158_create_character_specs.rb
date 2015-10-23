class CreateCharacterSpecs < ActiveRecord::Migration
  def change
    create_table :character_specs do |t|

      t.string :name
      t.string :role
      t.string :background_image
      t.string :icon
      t.string :description
      t.integer :order
      t.references :character_class, index: true, foreign_key: true
      t.timestamps
    end
  end
end
