class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    #nameに一意制約を追加
    add_index :users, :name, unique: true
  end
end
