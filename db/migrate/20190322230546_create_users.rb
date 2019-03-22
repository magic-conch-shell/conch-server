class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :phone
      t.string :email
      t.string :password_digest
      t.boolean :is_mentor
      t.integer :points

      t.timestamps
    end
  end
end
