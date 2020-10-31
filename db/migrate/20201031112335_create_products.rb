class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :quantili, null: false
      t.string :code, null: false

      t.timestamps
    end
    add_index :products, :name, unique: true
    add_index :products, :code, unique: true
  end
end
