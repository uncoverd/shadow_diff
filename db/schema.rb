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

ActiveRecord::Schema.define(version: 20170701134842) do

  create_table "commits", force: :cascade do |t|
    t.float    "score"
    t.string   "description"
    t.string   "commit_hash"
    t.string   "commit_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["commit_hash"], name: "index_commits_on_commit_hash", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "commit_id"
    t.integer  "url_id"
    t.string   "request_id"
    t.text     "production"
    t.text     "shadow"
    t.datetime "time"
    t.float    "score"
    t.text     "request"
    t.string   "verb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commit_id"], name: "index_responses_on_commit_id"
    t.index ["url_id"], name: "index_responses_on_url_id"
  end

  create_table "rules", force: :cascade do |t|
    t.float    "modifier"
    t.string   "name"
    t.string   "regex_string"
    t.integer  "url_id"
    t.integer  "commit_id"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["commit_id"], name: "index_rules_on_commit_id"
    t.index ["url_id"], name: "index_rules_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string   "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
