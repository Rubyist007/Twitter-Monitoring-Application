require './app/models/user.rb'
require './app/models/tracked_user.rb'
require './app/models/tweet.rb'

namespace :db do
  db_config = YAML.load(File.open('./config/database.yml'))
  db_config_admin = db_config.merge({ 'database' => 'postgres','schema_search_path' => 'public' })

  connect_to_db = Proc.new { |config| ActiveRecord::Base.establish_connection(config) }
  db_action = Proc.new { |action| ActiveRecord::Base.connection.send(action, db_config['database']) }

  desc 'Create the database'
  task :create do
    connect_to_db.call(db_config_admin)
    db_action.call('create_database', db_config['database'])

    p 'Database created.'
  end

  desc 'Migrate the database'
  task :migrate do
    connect_to_db.call(db_config)

    ActiveRecord::Migrator.migrate('./db/migrate/')
    Rake::Task['db:schema'].invoke

    p 'Database migrated.'
  end

  desc 'Drop the database'
  task :drop do
    connect_to_db.call(db_config_admin)
    db_action.call('drop_database', db_config['database'])

    p 'Database deleted.'   
  end

  desc 'Reset the database'
  task reset: %w(db:drop db:create db:migrate db:seed)

  desc 'Setup database'
  task setup: %w(db:create db:migrate db:seed)

  desc 'Create a db/schema.db file'
  task :schema do
    connect_to_db.call(db_config)
    require 'active_record/schema_dumper'
    File.open('db/schema.rb', 'w:utf-8') do |file| 
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end

  desc 'Seeds db'
  task :seed do
    User.create!({nickname: 'test', password: '123'})
    p 'Database seeds.'
  end
    
  desc 'Reset the database'
  task fetchdata: %w(db:get_new_tweets)

  desc 'fetched data'
  task :get_new_tweers do
    users = TrackedUser.all

    users.each do |user|
      since_id = user.tweets.first.tweet_id
      tweets = client.user_timeline(user.twitter_id, since_id: since_id)

      tweets.each do |tweet|
        params = { tweet_id: tweet.id, text: tweet.full_text, autor: user.twetter_id}
        user.tweets.create(params)
      end 
    end    
  end
end
