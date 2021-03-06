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

ActiveRecord::Schema.define(version: 20160731052553) do

  create_table "comments", force: :cascade do |t|
    t.integer  "order_id",    limit: 4
    t.integer  "user_id",     limit: 4
    t.text     "content",     limit: 65535
    t.boolean  "delete_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "simple_name", limit: 255
    t.string   "full_name",   limit: 255
    t.string   "phone",       limit: 255
    t.string   "address",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conditions", force: :cascade do |t|
    t.integer  "noble_metal_id", limit: 4
    t.integer  "relation",       limit: 4
    t.float    "value",          limit: 24
    t.boolean  "is_valid",                  default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "customers_companies", id: false, force: :cascade do |t|
    t.integer  "customer_id", limit: 4
    t.integer  "company_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delete_flag"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "general_products", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "seller_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id", limit: 4
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "customer_id",     limit: 4
    t.integer  "supplier_id",     limit: 4
    t.text     "content",         limit: 65535
    t.datetime "need_reach_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "noble_metal_prices", force: :cascade do |t|
    t.integer  "noble_metal_id", limit: 4
    t.float    "price",          limit: 24
    t.date     "trade_date"
    t.time     "trade_time"
    t.string   "week",           limit: 255
    t.float    "change_percent", limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "noble_metals", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",    limit: 4
    t.integer  "product_id",  limit: 4
    t.integer  "price_id",    limit: 4
    t.string   "plan_weight", limit: 255
    t.float    "real_weight", limit: 24
    t.float    "money",       limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delete_flag"
  end

  create_table "order_types", force: :cascade do |t|
    t.integer  "customer_id", limit: 4
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id", limit: 4
    t.boolean  "delete_flag"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id",      limit: 4
    t.integer  "store_id",         limit: 4
    t.integer  "order_type_id",    limit: 4
    t.date     "reach_order_date"
    t.date     "send_order_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",          limit: 4
    t.boolean  "delete_flag"
    t.integer  "supplier_id",      limit: 4
    t.integer  "not_input_number", limit: 4
    t.boolean  "return_flag"
  end

  create_table "price_change_histories", force: :cascade do |t|
    t.integer  "price_id",    limit: 4
    t.float    "from_price",  limit: 24
    t.float    "to_price",    limit: 24
    t.datetime "change_time"
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "year_month_id", limit: 4
    t.integer  "customer_id",   limit: 4
    t.integer  "product_id",    limit: 4
    t.float    "price",         limit: 24
    t.boolean  "is_used"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "true_spec",     limit: 255
    t.integer  "supplier_id",   limit: 4
    t.integer  "print_times",   limit: 4,   default: 0
  end

  create_table "print_order_notices", force: :cascade do |t|
    t.integer "supplier_id", limit: 4
    t.integer "customer_id", limit: 4
    t.string  "notice",      limit: 2000
  end

  create_table "products", force: :cascade do |t|
    t.string   "english_name",       limit: 255
    t.string   "chinese_name",       limit: 255
    t.string   "simple_abc",         limit: 255
    t.string   "spec",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id",        limit: 4
    t.integer  "general_product_id", limit: 4
    t.integer  "print_times",        limit: 4,   default: 0
  end

  create_table "sellers", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "shop_name",   limit: 255
    t.string   "phone",       limit: 255
    t.string   "address",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id", limit: 4
    t.integer  "sort_number", limit: 4,   default: 0
  end

  create_table "stores", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test", force: :cascade do |t|
    t.string "name", limit: 32
  end

  create_table "tieba_messages", force: :cascade do |t|
    t.text    "content", limit: 65535
    t.integer "is_used", limit: 4
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
    t.integer  "company_id",             limit: 4
    t.string   "user_name",              limit: 255
    t.string   "terminal_password",      limit: 255
    t.string   "serial_number",          limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vip_authorities", force: :cascade do |t|
    t.integer  "vip_type",                 limit: 4
    t.integer  "customer_count",           limit: 4
    t.integer  "print_able_per_day_count", limit: 4
    t.integer  "product_count",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vip_infos", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.integer  "vip_type",   limit: 4
    t.date     "valid_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "year_months", force: :cascade do |t|
    t.string   "val",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
