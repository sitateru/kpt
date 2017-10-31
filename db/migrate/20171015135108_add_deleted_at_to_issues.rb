class AddDeletedAtToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :deleted_at, :datetime
    add_index :issues, :deleted_at
  end
end
