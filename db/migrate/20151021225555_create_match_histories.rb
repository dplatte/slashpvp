class CreateMatchHistories < ActiveRecord::Migration
  def change
    create_table :match_histories do |t|
      t.boolean :victory
      t.integer :rating_change
      t.integer :rank_change
      t.references :region, index: true
      t.references :bracket, index: true
      t.belongs_to :character, index: true, foreign_key: true
      t.timestamps
    end
  end
end
