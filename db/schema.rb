# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180204170235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tracked_users", id: :serial, force: :cascade do |t|
    t.bigint "twitter_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracked_users_users", id: false, force: :cascade do |t|
    t.bigint "tracked_user_id"
    t.bigint "user_id"
    t.index ["tracked_user_id", "user_id"], name: "index_tracked_users_users_on_tracked_user_id_and_user_id", unique: true
    t.index ["tracked_user_id"], name: "index_tracked_users_users_on_tracked_user_id"
    t.index ["user_id"], name: "index_tracked_users_users_on_user_id"
  end

  create_table "tweets", id: :serial, force: :cascade do |t|
    t.bigint "tweet_id"
    t.integer "tracked_user_id"
    t.string "text"
    t.string "autor"
    t.datetime "posted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tracked_user_id"], name: "index_tweets_on_tracked_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "nickname"
    t.string "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
