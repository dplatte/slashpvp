class CreateSpells < ActiveRecord::Migration
  def change
    create_table :spells do |t|

      t.string :name
      t.string :icon
      t.string :description
      t.string :range
      t.string :power_cost
      t.string :cast_time
      t.string :cooldown
      t.timestamps
    end
  end
end
