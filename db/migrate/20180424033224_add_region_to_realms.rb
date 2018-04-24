class AddRegionToRealms < ActiveRecord::Migration
  def change
  	add_reference :realms, :region, index: true
  	region = Region.find_by_abbr('us')
  	Realm.find_each do |realm|
		realm.region_id = region.id
		realm.save!
    end
  end
end
