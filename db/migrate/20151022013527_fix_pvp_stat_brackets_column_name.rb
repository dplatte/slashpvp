class FixPvpStatBracketsColumnName < ActiveRecord::Migration
  def change
    rename_column :pvp_stats, :brackets_id, :bracket_id
  end
end
