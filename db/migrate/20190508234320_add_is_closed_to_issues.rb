class AddIsClosedToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :is_closed, :boolean, default: false, null: false
  end
end
