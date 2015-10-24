class AddRetrievedTimeToMatchHistories < ActiveRecord::Migration
  def change
  	add_column :match_histories, :retrieved_time, :datetime
  end
end
