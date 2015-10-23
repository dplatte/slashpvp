class RemoveRealmFromCharacters < ActiveRecord::Migration
  def change
    remove_reference :characters, :region, index: true
  end
end
