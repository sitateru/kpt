class AddIsCloseToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :is_close, :boolean, default: false, null: false
  end
end
