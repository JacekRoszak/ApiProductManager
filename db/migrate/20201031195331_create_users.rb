class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.boolean :admin, null: false, default: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
