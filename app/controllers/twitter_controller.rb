require './app/models/user.rb'
require './app/models/tracked_user.rb'
require './app/models/tweet.rb'
require './app/controllers/concerns/Callback.rb'
require './app/controllers/application_controller.rb'

require 'twitter'

class TwitterController < BaseController
  attr_accessor :client, :tweets, :tracked_users

  def initialize(request)
    super(request)
        
    set_twitter_connect 
    authenticate!(:index, :track_user, :search_user, :feed)
  end

  def index
    self.tracked_users = current_user.tracked_users

    render('twitter/index') { tracked_users }
  end

  def feed
    tweets = []
    current_user.tracked_users.includes(:tweets).each do |user|
      tweets << user.tweets
    end
    
    render('twitter/feed') { self.tweets = tweets.flatten }
  end

  def track_user(params)
    user_in_db = TrackedUser.where(twitter_id: params['twitter_id'])[0]
    if user_in_db != nil
      current_user.tracked_users<<(user_in_db)
    else
      tracked_user = TrackedUser.new(params)
      current_user.tracked_users<<(tracked_user)
      tweet_upload(tracked_user)
    end
    render_json('Success!'.to_json)
  rescue ActiveRecord::RecordNotUnique
    render_json('Already traking!'.to_json)
  end

  def untrack_user(params)
    current_user.tracked_users.delete(TrackedUser.find(params['id']))
    render_json(params.to_json)
  end

  def search_user(params)
    user = client.user(params['nickname']) 
    render_json(user.to_json)
  rescue Twitter::Error::NotFound 
      render_json('No found!'.to_json)
  end

  private
 
    def set_twitter_connect
      self.client = Twitter::REST::Client.new do |config|
        config.consumer_key = 'wSCOz5jUN4DLfoj2gM9E6w0D8'
        config.consumer_secret = 'rdNfXG2ds2HsHngUYUlccuRnmbYxeYFvJjZAgHsbE9tQepHoKi'
        config.access_token = '812300445528027136-k9NC9Do9yppQwmpBdkMI9FQl1KtHwP3'
        config.access_token_secret = 'nwjNrgr0hDTJazM2lPe5oSuLJSJ6mzl53S0dp5WZjHIFw'
      end
    end

    def tweet_upload(user)
      tweets = client.user_timeline(user.twitter_id)
      #p client.status(tweets.first.id).to_json
      #p client.search("q=to#{user.twitter_id}, sinceld = #{tweets.first.id}")
      tweets.each do |tweet|
        params = { tweet_id: tweet.id, text: tweet.full_text, autor: user.name, posted_at: tweet.created_at }
        user.tweets.create(params)
      end
    end
end
