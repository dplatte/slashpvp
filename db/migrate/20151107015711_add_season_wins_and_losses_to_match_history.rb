class AddSeasonWinsAndLossesToMatchHistory < ActiveRecord::Migration
  def change
  	add_column :match_histories, :season_wins, :integer
    add_column :match_histories, :season_losses, :integer
  end
end
