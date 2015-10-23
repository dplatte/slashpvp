class AddLocaleToRegions < ActiveRecord::Migration
  def change
    remove_column :regions, :locale, :string
    add_reference :regions, :locale, index: true
  end
end
