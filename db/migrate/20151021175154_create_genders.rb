class CreateGenders < ActiveRecord::Migration
  def change
    create_table(:genders, :id => false) do |t|
      t.integer :id, :options => 'PRIMARY KEY'
      t.string :name
      t.timestamps
    end
  end
end
