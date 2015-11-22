class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
    	t.string :name
    	t.decimal :percentage
    	t.integer :rating
    	t.integer :ranking
    	t.integer :lowest_ranking
    	t.references :bracket, index: true, foreign_key: true
    	t.references :region, index: true, foreign_key: true
    	t.timestamps
    end
  end
end
