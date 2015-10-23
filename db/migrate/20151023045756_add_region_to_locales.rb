class AddRegionToLocales < ActiveRecord::Migration
  def change
    add_reference :locales, :region, index: true
  end
end
