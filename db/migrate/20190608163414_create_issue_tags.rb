class CreateIssueTags < ActiveRecord::Migration[5.1]
  def change
    create_table :issue_tags do |t|
      t.references :issue, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false

      t.timestamps

      t.index [:issue_id, :tag_id], unique: true
    end
  end
end
