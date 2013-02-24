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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130224201457) do

  create_table "attendances", :force => true do |t|
    t.text     "comment"
    t.decimal  "days_registered",   :precision => 10, :scale => 0
    t.decimal  "days_participated", :precision => 10, :scale => 0
    t.boolean  "paid"
    t.decimal  "fee",               :precision => 10, :scale => 0
    t.integer  "user_id"
    t.integer  "lan_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.datetime "registration_date"
  end

  add_index "attendances", ["lan_id"], :name => "index_attendances_on_lan_id"
  add_index "attendances", ["user_id"], :name => "index_attendances_on_user_id"

  create_table "faqs", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "link"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "screenshot_file_name"
    t.string   "screenshot_content_type"
    t.integer  "screenshot_file_size"
    t.datetime "screenshot_updated_at"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "lans", :force => true do |t|
    t.string   "place"
    t.datetime "starttime"
    t.datetime "endtime"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "registration_open"
    t.text     "description"
  end

  create_table "mail_queues", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "error"
  end

  create_table "mailinglists", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "poll_options", :force => true do |t|
    t.integer  "poll_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "poll_votes", :force => true do |t|
    t.integer  "poll_id"
    t.integer  "user_id"
    t.integer  "poll_option_id"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "weight"
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.integer  "owner_id"
    t.integer  "lan_id"
    t.string   "type"
    t.datetime "expiration_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "description"
  end

  add_index "polls", ["owner_id"], :name => "index_polls_on_owner_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "users", :force => true do |t|
    t.string   "nick"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "admin"
    t.string   "password_hash"
    t.string   "password_salt"
  end

end
