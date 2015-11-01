class AddDomainToRegion < ActiveRecord::Migration
  def change
  	add_column :regions, :domain, :string
  end
end
