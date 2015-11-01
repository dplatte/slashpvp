class AddDisplayNameToBracket < ActiveRecord::Migration
  def change
  	add_column :brackets, :display_name, :string
  end
end
