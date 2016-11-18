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

ActiveRecord::Schema.define(version: 20160816062519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text     "comment_body"
    t.integer  "user_id"
    t.integer  "describe_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "describes", force: :cascade do |t|
    t.text     "title"
    t.string   "category"
    t.text     "short_description"
    t.text     "background"
    t.text     "impact"
    t.text     "need"
    t.text     "risks"
    t.text     "others"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name"
    t.string   "file"
    t.integer  "user_originator_id"
    t.boolean  "published",          default: false
  end

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "goals", force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "describe_id"
    t.integer  "priority"
  end

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "need_comments", force: :cascade do |t|
    t.text     "body_description"
    t.integer  "user_id"
    t.integer  "need_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "needs", force: :cascade do |t|
    t.string   "quantity"
    t.string   "unit"
    t.string   "need_decription"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "task_id"
    t.string   "need_name"
    t.string   "need_type"
    t.boolean  "priority",           default: false
    t.integer  "task_suggestion_id"
    t.boolean  "checked",            default: false
  end

  create_table "pledges", force: :cascade do |t|
    t.text     "pledge_content"
    t.integer  "user_contributor_id"
    t.integer  "need_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "quantity"
    t.string   "unit"
    t.boolean  "pledged"
  end

  create_table "task_suggestions", force: :cascade do |t|
    t.string   "suggestion_title"
    t.date     "date"
    t.time     "time"
    t.string   "description"
    t.string   "venue"
    t.string   "timezone"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "describe_id"
    t.boolean  "suggestion_status", default: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "goal_id"
    t.string   "title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.date     "date"
    t.time     "time"
    t.string   "description"
    t.string   "venue"
    t.string   "timezone"
    t.integer  "task_suggestion_id"
    t.integer  "priority"
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "company"
    t.string   "location"
    t.string   "timezone"
    t.string   "websites",               default: [],              array: true
    t.string   "about_me"
    t.string   "interests",              default: [],              array: true
    t.string   "file"
    t.string   "name"
  end

end
