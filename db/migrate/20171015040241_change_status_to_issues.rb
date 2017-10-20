class ChangeStatusToIssues < ActiveRecord::Migration[5.1]
  def change
    change_column_default :issues, :status, 1
  end
end
