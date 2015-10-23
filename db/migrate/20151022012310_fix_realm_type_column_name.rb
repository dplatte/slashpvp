class FixRealmTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :realms, :type, :realm_type
  end
end
