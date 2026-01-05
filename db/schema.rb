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

ActiveRecord::Schema[8.1].define(version: 2025_12_30_213815) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audit_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action_type", null: false, comment: "earn, redeem, admin_adjust, tier_change"
    t.uuid "admin_id", comment: "Could be mall_admin_id or shop_admin_id"
    t.string "admin_type", comment: "mall_admin, shop_admin"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.jsonb "metadata"
    t.integer "points"
    t.uuid "shop_id"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id"
    t.index ["action_type"], name: "index_audit_logs_on_action_type"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["shop_id"], name: "index_audit_logs_on_shop_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "end_date"
    t.string "name"
    t.uuid "shop_id"
    t.datetime "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_campaigns_on_shop_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active"
    t.string "category_name", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "description"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["category_name"], name: "index_categories_on_category_name", unique: true
  end

  create_table "categories_shops", id: false, force: :cascade do |t|
    t.uuid "category_id", null: false
    t.uuid "shop_id", null: false
    t.index ["category_id"], name: "index_categories_shops_on_category_id"
    t.index ["shop_id", "category_id"], name: "index_categories_shops_on_shop_id_and_category_id", unique: true
    t.index ["shop_id"], name: "index_categories_shops_on_shop_id"
  end

  create_table "earn_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "points_earned", null: false
    t.decimal "purchase_amount", precision: 10, scale: 2, null: false
    t.uuid "shop_id", null: false
    t.string "transaction_ref", comment: "actual receipt number(the white receipt)"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id", null: false
    t.index ["created_at"], name: "index_earn_transactions_on_created_at"
    t.index ["shop_id"], name: "index_earn_transactions_on_shop_id"
    t.index ["user_id"], name: "index_earn_transactions_on_user_id"
  end

  create_table "mall_admins", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Manages entire mall - can view all shops in their mall", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", null: false
    t.string "encrypted_password"
    t.uuid "mall_id", null: false
    t.string "name", null: false
    t.string "password_hash", null: false
    t.string "phone", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["email"], name: "index_mall_admins_on_email", unique: true
    t.index ["mall_id"], name: "index_mall_admins_on_mall_id"
    t.index ["phone"], name: "index_mall_admins_on_phone", unique: true
  end

  create_table "malls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "location"
    t.string "mall_name", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["mall_name"], name: "index_malls_on_mall_name", unique: true
  end

  create_table "offer_redemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "offer_id", null: false
    t.uuid "redemption_ref"
    t.uuid "shop_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id", null: false
    t.index ["offer_id"], name: "index_offer_redemptions_on_offer_id"
    t.index ["shop_id"], name: "index_offer_redemptions_on_shop_id"
    t.index ["user_id"], name: "index_offer_redemptions_on_user_id"
  end

  create_table "offers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "description"
    t.datetime "end_date", precision: nil
    t.string "name", null: false
    t.integer "redemptions_count"
    t.string "reward_type", null: false, comment: "free_item, discount, points"
    t.jsonb "reward_value"
    t.uuid "shop_id", null: false
    t.datetime "start_date", precision: nil, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["active"], name: "index_offers_on_active"
    t.index ["shop_id"], name: "index_offers_on_shop_id"
  end

  create_table "point_value_histories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "admin_id"
    t.datetime "created_at", null: false
    t.datetime "effective_date", null: false
    t.decimal "new_value", precision: 10, scale: 4
    t.decimal "old_value", precision: 10, scale: 4
    t.text "reason"
    t.datetime "updated_at", null: false
    t.index ["effective_date"], name: "index_point_value_histories_on_effective_date"
  end

  create_table "qrs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "shop_id"
    t.uuid "user_id"
    t.index ["shop_id"], name: "index_qrs_on_shop_id"
    t.index ["user_id"], name: "index_qrs_on_user_id"
  end

  create_table "receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount", null: false
    t.jsonb "receipt_details", null: false
    t.string "receipt_path"
    t.uuid "shop_id", null: false
    t.uuid "user_id", null: false
    t.index ["shop_id"], name: "index_receipts_on_shop_id"
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "redeem_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.decimal "discount_value", precision: 10, scale: 2, null: false
    t.integer "points_used", null: false
    t.uuid "shop_id", null: false
    t.string "status", default: "pending", null: false, comment: "pending, verified, completed, cancelled"
    t.uuid "user_id", null: false
    t.string "verification_code", limit: 6, null: false
    t.index ["created_at"], name: "index_redeem_transactions_on_created_at"
    t.index ["shop_id"], name: "index_redeem_transactions_on_shop_id"
    t.index ["status"], name: "index_redeem_transactions_on_status"
    t.index ["user_id"], name: "index_redeem_transactions_on_user_id"
    t.index ["verification_code"], name: "index_redeem_transactions_on_verification_code"
  end

  create_table "shop_admins", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Manages specific shop - can create programs, verify redemptions", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", null: false
    t.string "encrypted_password"
    t.boolean "is_active", default: true
    t.string "name", null: false
    t.string "password_hash", null: false
    t.string "phone", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.uuid "shop_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["email"], name: "index_shop_admins_on_email", unique: true
    t.index ["phone"], name: "index_shop_admins_on_phone", unique: true
    t.index ["shop_id"], name: "index_shop_admins_on_shop_id"
  end

  create_table "shop_points_wallets", primary_key: "shop_id", id: :uuid, default: nil, force: :cascade do |t|
    t.datetime "last_updated", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.integer "points_received", default: 0, null: false
  end

  create_table "shops", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "is_active", default: true
    t.uuid "mall_id", null: false
    t.string "name", null: false
    t.string "status"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["mall_id"], name: "index_shops_on_mall_id"
    t.index ["name"], name: "index_shops_on_name", unique: true
  end

  create_table "stamp_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "redemption_ref"
    t.uuid "shop_id", null: false
    t.uuid "stamp_id", null: false
    t.integer "stamps_count", null: false
    t.string "type", null: false, comment: "activation, stamp, redeem_reward"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id", null: false
    t.index ["created_at"], name: "index_stamp_transactions_on_created_at"
    t.index ["shop_id"], name: "index_stamp_transactions_on_shop_id"
    t.index ["stamp_id"], name: "index_stamp_transactions_on_stamp_id"
    t.index ["type"], name: "index_stamp_transactions_on_type"
    t.index ["user_id"], name: "index_stamp_transactions_on_user_id"
  end

  create_table "stamps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "description"
    t.datetime "end_date", precision: nil
    t.datetime "expiration_limit", precision: nil, null: false
    t.string "name", null: false
    t.string "reward_type", null: false, comment: "free_item, discount"
    t.jsonb "reward_value"
    t.uuid "shop_id", null: false
    t.integer "stamps_limit"
    t.integer "stamps_required", null: false
    t.datetime "start_date", precision: nil, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["active"], name: "index_stamps_on_active"
    t.index ["shop_id"], name: "index_stamps_on_shop_id"
  end

  create_table "system_configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.jsonb "value", default: {}, null: false
    t.index ["key"], name: "index_system_configurations_on_key", unique: true
  end

  create_table "tiers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "benefits", comment: "Multipliers, perks, etc"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "points_required", default: 0, null: false
    t.string "tier_name", null: false, comment: "Bronze, Silver, Gold, Platinum"
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["tier_name"], name: "index_tiers_on_tier_name", unique: true
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", precision: nil, null: false
    t.uuid "receipt_id"
    t.uuid "shop_id"
    t.uuid "user_id"
    t.index ["receipt_id"], name: "index_transactions_on_receipt_id"
    t.index ["shop_id"], name: "index_transactions_on_shop_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_points_balances", primary_key: "user_id", id: :uuid, default: nil, force: :cascade do |t|
    t.datetime "last_updated", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.integer "lifetime_points", default: 0, null: false, comment: "For tier calculation"
    t.integer "total_points", default: 0, null: false
  end

  create_table "user_stamp_cards", primary_key: ["user_id", "stamp_id"], force: :cascade do |t|
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "is_completed", default: false, null: false
    t.datetime "last_transaction", precision: nil, null: false
    t.uuid "stamp_id", null: false
    t.integer "stamps_counter", default: 0, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id", null: false
    t.index ["is_completed"], name: "index_user_stamp_cards_on_is_completed"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Regular customers who earn points", force: :cascade do |t|
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", null: false
    t.string "firstname", null: false
    t.string "gender", null: false
    t.string "lastname", null: false
    t.string "password_hash", null: false
    t.string "phone", null: false
    t.uuid "tier_id", null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["tier_id"], name: "index_users_on_tier_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "shops"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "categories_shops", "categories"
  add_foreign_key "categories_shops", "shops"
  add_foreign_key "earn_transactions", "shops"
  add_foreign_key "earn_transactions", "users"
  add_foreign_key "mall_admins", "malls"
  add_foreign_key "offer_redemptions", "offers"
  add_foreign_key "offer_redemptions", "receipts", column: "redemption_ref"
  add_foreign_key "offer_redemptions", "shops"
  add_foreign_key "offer_redemptions", "users"
  add_foreign_key "offers", "shops"
  add_foreign_key "qrs", "shops"
  add_foreign_key "qrs", "users"
  add_foreign_key "receipts", "shops"
  add_foreign_key "receipts", "users"
  add_foreign_key "redeem_transactions", "shops"
  add_foreign_key "redeem_transactions", "users"
  add_foreign_key "shop_admins", "shops"
  add_foreign_key "shop_points_wallets", "shops"
  add_foreign_key "shops", "malls"
  add_foreign_key "stamp_transactions", "receipts", column: "redemption_ref"
  add_foreign_key "stamp_transactions", "shops"
  add_foreign_key "stamp_transactions", "stamps"
  add_foreign_key "stamp_transactions", "users"
  add_foreign_key "stamps", "shops"
  add_foreign_key "transactions", "receipts"
  add_foreign_key "transactions", "shops"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_points_balances", "users"
  add_foreign_key "user_stamp_cards", "stamps"
  add_foreign_key "user_stamp_cards", "users"
  add_foreign_key "users", "tiers"
end
