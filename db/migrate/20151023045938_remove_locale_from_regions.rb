class RemoveLocaleFromRegions < ActiveRecord::Migration
  def change
    remove_reference :regions, :locale, index: true
  end
end
