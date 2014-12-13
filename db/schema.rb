# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141213035037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "twitter_accounts", force: true do |t|
    t.string   "uid"
    t.string   "screen_name"
    t.string   "profile_image_url"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_accounts", ["user_id"], name: "index_twitter_accounts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
