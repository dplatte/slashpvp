class AddRegionToCharacters < ActiveRecord::Migration
  def change
    add_reference :characters, :region, index: true
  end
end
