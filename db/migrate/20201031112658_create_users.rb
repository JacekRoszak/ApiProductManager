class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :password, null: false
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :login, unique: true
  end
end
