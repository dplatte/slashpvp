class ChangeSpellDescriptionDataType < ActiveRecord::Migration
  def change
  	change_column :spells, :description, :text
  end
end
