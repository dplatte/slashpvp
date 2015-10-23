class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|

      t.string :name
      t.integer :player_count
      t.timestamps
    end
  end
end
