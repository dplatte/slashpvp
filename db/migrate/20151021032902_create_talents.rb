class CreateTalents < ActiveRecord::Migration
  def change
    create_table :talents do |t|
      t.integer :tier
      t.integer :column
      t.references :character_class, index: true, foreign_key: true
      t.references :spell, index: true, foreign_key: true
      t.timestamps
    end
  end
end
