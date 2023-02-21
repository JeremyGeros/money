# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_21_175135) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "bank", null: false
    t.string "name", null: false
    t.string "account_number"
    t.integer "currency", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "starting_balance", default: 0.0
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.string "name"
    t.bigint "account_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "total_transactions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_imports_on_account_id"
  end

  create_table "matcher_transactions", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.bigint "matcher_id", null: false
    t.string "original_name", null: false
    t.string "new_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matcher_id"], name: "index_matcher_transactions_on_matcher_id"
    t.index ["transaction_id"], name: "index_matcher_transactions_on_transaction_id"
  end

  create_table "matchers", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "match_regex", null: false
    t.string "replacer"
    t.datetime "enabled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_matchers_on_account_id"
  end

  create_table "spends", force: :cascade do |t|
    t.string "name"
    t.integer "category", default: 0, null: false
    t.integer "spend_group", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_details"
    t.string "lookups", default: [], array: true
    t.boolean "always_positive", default: false
    t.boolean "ignored", default: false, null: false
    t.integer "kind", default: 0, null: false
    t.boolean "generic", default: false, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "made_at"
    t.string "details"
    t.float "amount"
    t.boolean "ignored", default: false, null: false
    t.integer "currency", default: 0, null: false
    t.integer "kind", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "spend_id"
    t.string "name"
    t.float "balance"
    t.boolean "personal_transfer", default: false, null: false
    t.integer "transfer_transaction_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "key"
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_user_sessions_on_key", unique: true
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "imports", "accounts"
  add_foreign_key "matcher_transactions", "matchers"
  add_foreign_key "matcher_transactions", "transactions"
  add_foreign_key "matchers", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "user_sessions", "users"
end
