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

ActiveRecord::Schema.define(version: 20150531011435) do

  create_table "agents", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "img",        limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "language",   limit: 255
  end

  create_table "black_lists", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.string   "ip",         limit: 255
    t.integer  "flag",       limit: 4
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "black_lists", ["email"], name: "index_black_lists_on_email", using: :btree
  add_index "black_lists", ["ip"], name: "index_black_lists_on_ip", using: :btree
  add_index "black_lists", ["user"], name: "index_black_lists_on_user", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "user",         limit: 4
    t.integer  "friend_id",    limit: 4
    t.integer  "reason_id",    limit: 4
    t.date     "begin_date"
    t.string   "period",       limit: 255
    t.integer  "duration_day", limit: 4
    t.integer  "shift_day",    limit: 4
    t.integer  "color",        limit: 4
    t.integer  "status",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "events", ["friend_id"], name: "index_events_on_friend_id", using: :btree
  add_index "events", ["reason_id"], name: "index_events_on_reason_id", using: :btree

  create_table "friends", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.string   "img",        limit: 255
    t.integer  "cycle_day",  limit: 4
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "gender",     limit: 1
  end

  add_index "friends", ["user_id"], name: "index_friends_on_user_id", using: :btree

  create_table "froms", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "language",   limit: 255
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "letter_id",  limit: 4
    t.integer  "status",     limit: 4
    t.integer  "event_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "histories", ["event_id"], name: "index_histories_on_event_id", using: :btree
  add_index "histories", ["letter_id"], name: "index_histories_on_letter_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.string   "who",        limit: 255
    t.integer  "refer",      limit: 4
    t.string   "url",        limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "letters", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.integer  "event_id",   limit: 4
    t.integer  "from_id",    limit: 4
    t.integer  "message_id", limit: 4
    t.integer  "agent",      limit: 4
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "letters", ["agent"], name: "index_letters_on_agent", using: :btree
  add_index "letters", ["event_id"], name: "index_letters_on_event_id", using: :btree
  add_index "letters", ["from_id"], name: "index_letters_on_from_id", using: :btree
  add_index "letters", ["message_id"], name: "index_letters_on_message_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user",       limit: 4
    t.string   "theme",      limit: 255
    t.string   "text",       limit: 255
    t.integer  "status",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "language",   limit: 255
  end

  create_table "reasons", force: :cascade do |t|
    t.integer  "user",         limit: 4
    t.string   "name",         limit: 255
    t.string   "period",       limit: 255
    t.integer  "duration_day", limit: 4
    t.integer  "status",       limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "language",     limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.boolean  "gender",                 limit: 1
    t.integer  "status",                 limit: 4
    t.date     "paid"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.date     "birthday"
    t.integer  "cycle_day",              limit: 4
    t.date     "begin"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "events", "friends"
  add_foreign_key "events", "reasons"
  add_foreign_key "friends", "users"
  add_foreign_key "histories", "letters"
  add_foreign_key "histories", "users"
  add_foreign_key "letters", "events"
  add_foreign_key "letters", "froms"
  add_foreign_key "letters", "messages"
end
