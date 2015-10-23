class CreateRealms < ActiveRecord::Migration
  def change
    create_table :realms do |t|
      t.string :name
      t.string :slug
      t.string :type
      t.string :population
      t.boolean :queue
      t.boolean :status
      t.string :timezone
      t.string :locale 
      t.timestamps
    end
  end
end
