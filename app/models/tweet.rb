class Tweet < ActiveRecord::Base
  validates_presence_of :tweet_id, :tracked_user_id, :text
  validates_uniqueness_of :tweet_id

  belongs_to :tracked_users 

  default_scope { order(posted_at: :desc ) }

end
