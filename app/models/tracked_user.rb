class TrackedUser < ActiveRecord::Base
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id

  has_and_belongs_to_many :users, uniq: true
  has_many :tweets 
end
