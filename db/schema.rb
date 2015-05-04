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

ActiveRecord::Schema.define(version: 20131127171024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "algorithm_test_runs", force: true do |t|
    t.string   "algorithm",    null: false
    t.hstore   "config",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "error_metric", null: false
  end

  create_table "boat_listings", force: true do |t|
    t.string   "yw_id",            null: false
    t.text     "yw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "length"
    t.integer  "year_of_boat"
    t.integer  "listed_price"
    t.integer  "sold_price"
    t.datetime "date_listed"
    t.datetime "date_sold"
    t.string   "location"
    t.string   "hull_material"
    t.string   "engine_fuel_type"
    t.string   "headline"
  end

  add_index "boat_listings", ["yw_id"], name: "index_boat_listings_on_yw_id", unique: true, using: :btree

end
