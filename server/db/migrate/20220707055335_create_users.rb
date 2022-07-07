class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 255
      t.string :last_name, limit: 255
      t.string :email, limit: 255
      t.string :password, limit: 100
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
