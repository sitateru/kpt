class CreateIssueTags < ActiveRecord::Migration[5.1]
  def change
    create_table :issue_tags do |t|
      t.references :issue, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
