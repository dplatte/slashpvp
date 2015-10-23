class RemoveRealmFromCharacters2 < ActiveRecord::Migration
  def change
    remove_reference :characters, :realm, index: true
  end
end