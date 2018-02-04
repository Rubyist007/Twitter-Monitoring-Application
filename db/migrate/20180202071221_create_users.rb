class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :password_hash

      t.timestamps
    end      
  end
end
