class AddCharacterSpecRefToTalents < ActiveRecord::Migration
  def change
    add_reference :talents, :character_spec, index: true, foreign_key: true
  end
end
