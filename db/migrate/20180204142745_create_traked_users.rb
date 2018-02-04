class CreateTrakedUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :tracked_users do |t|
      t.bigint :twitter_id 

      t.timestamps
    end
  end
end
