class AddHistoryColumnsToMatchHistories < ActiveRecord::Migration
  def change
  	add_column :match_histories, :old_rating, :integer
  	add_column :match_histories, :new_rating, :integer
  	add_column :match_histories, :old_ranking, :integer
  	add_column :match_histories, :new_ranking, :integer
  end
end
