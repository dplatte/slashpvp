class AddIndexToCharacters < ActiveRecord::Migration
  def change
  	add_index(:characters, [:name, :realm_name, :bracket_id, :region_id], unique: true, name: 'by_name_realm_bracket_region')
  end
end
