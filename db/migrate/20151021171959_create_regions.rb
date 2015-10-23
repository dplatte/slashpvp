class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|

      t.string :name
      t.string :locale
      t.string :abbr
      t.timestamps
    end
  end
end
