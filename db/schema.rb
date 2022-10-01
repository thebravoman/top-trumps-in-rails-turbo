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

ActiveRecord::Schema[7.0].define(version: 2022_10_01_201603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accepts", force: :cascade do |t|
    t.bigint "top_trump_id", null: false
    t.integer "trick"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["top_trump_id"], name: "index_accepts_on_top_trump_id"
    t.index ["user_id"], name: "index_accepts_on_user_id"
  end

  create_table "card_categories", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.integer "numeric_value"
    t.index ["card_id"], name: "index_card_categories_on_card_id"
    t.index ["category_id"], name: "index_card_categories_on_category_id"
  end

  create_table "card_to_hands", force: :cascade do |t|
    t.bigint "hand_id", null: false
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_to_hands_on_card_id"
    t.index ["hand_id"], name: "index_card_to_hands_on_hand_id"
  end

  create_table "cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "description"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "hands", force: :cascade do |t|
    t.bigint "top_trump_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "index"
    t.index ["top_trump_id"], name: "index_hands_on_top_trump_id"
  end

  create_table "moves", force: :cascade do |t|
    t.integer "card_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "top_trump_id", null: false
    t.bigint "user_id", null: false
    t.bigint "card_id", null: false
    t.integer "trick"
    t.index ["card_id"], name: "index_moves_on_card_id"
    t.index ["top_trump_id"], name: "index_moves_on_top_trump_id"
    t.index ["user_id"], name: "index_moves_on_user_id"
  end

  create_table "top_trumps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.integer "current_trick", default: 1
    t.bigint "player1_id", null: false
    t.integer "player2_id"
    t.integer "lead_id"
    t.index ["lead_id"], name: "index_top_trumps_on_lead_id"
    t.index ["player1_id"], name: "index_top_trumps_on_player1_id"
    t.index ["player2_id"], name: "index_top_trumps_on_player2_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accepts", "top_trumps"
  add_foreign_key "accepts", "users"
  add_foreign_key "card_categories", "cards"
  add_foreign_key "card_categories", "categories"
  add_foreign_key "card_to_hands", "cards"
  add_foreign_key "card_to_hands", "hands"
  add_foreign_key "moves", "card_categories"
  add_foreign_key "moves", "cards"
  add_foreign_key "moves", "top_trumps"
  add_foreign_key "moves", "users"
  add_foreign_key "top_trumps", "users", column: "lead_id"
  add_foreign_key "top_trumps", "users", column: "player1_id"
  add_foreign_key "top_trumps", "users", column: "player2_id"
end
