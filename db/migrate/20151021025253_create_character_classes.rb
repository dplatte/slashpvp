class CreateCharacterClasses < ActiveRecord::Migration
  def change
    create_table :character_classes do |t|
      t.integer :mask
      t.string :power_type
      t.string :name
      t.timestamps
    end
  end
end
