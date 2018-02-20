class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :issue, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps

      t.index [:issue_id, :user_id], unique: true
    end
  end
end
