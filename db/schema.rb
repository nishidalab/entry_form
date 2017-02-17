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

ActiveRecord::Schema.define(version: 20170217154538) do

  create_table "experiments", force: :cascade do |t|
    t.integer  "member_id"
    t.date     "zisshi_ukagai_date"
    t.string   "project_owner"
    t.string   "place"
    t.string   "budget"
    t.string   "department_code"
    t.string   "project_num"
    t.string   "project_name"
    t.string   "creditor_code"
    t.integer  "expected_participant_count"
    t.integer  "duration"
    t.string   "name"
    t.string   "description"
    t.date     "schedule_from"
    t.date     "schedule_to"
    t.date     "final_report_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "yomi"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "participants", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.string   "yomi"
    t.integer  "gender"
    t.date     "birth"
    t.integer  "classification"
    t.integer  "grade"
    t.integer  "faculty"
    t.text     "address"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
    t.index ["email"], name: "index_participants_on_email", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "experiment_id"
    t.integer  "participant_id"
    t.datetime "datetime"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
