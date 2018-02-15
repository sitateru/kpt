class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.datetime :deleted_at
      t.timestamps

      t.index :deleted_at

      #nameに一意制約を付加,部分index対応のDB(pg)でのみ動作
      t.index :name, unique: true, where: "deleted_at IS NOT NULL"
    end
  end
end
