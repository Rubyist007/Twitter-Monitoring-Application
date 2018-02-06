class CreateTweets < ActiveRecord::Migration[4.2]
  def change
    create_table :tweets do |t|
      t.bigint :tweet_id
      t.belongs_to :tracked_user, index: true 
      t.string :text
      t.string :autor
      t.datetime :posted_at

      t.timestamps
    end
  end
end
