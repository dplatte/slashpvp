class UpdateCharacterColumns < ActiveRecord::Migration
  def change
    add_column :characters, :realm_name, :string
    add_column :characters, :rating, :integer
    add_column :characters, :ranking, :integer
    add_column :characters, :season_wins, :integer
    add_column :characters, :season_losses, :integer
    add_column :characters, :weekly_wins, :integer
    add_column :characters, :weekly_losses, :integer
    add_reference :characters, :bracket, index: true
    add_reference :characters, :region, index: true
  end
end
