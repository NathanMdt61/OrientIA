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

ActiveRecord::Schema[8.1].define(version: 2026_05_26_100327) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "hobbies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "hobbies_lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "hobbie_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["hobbie_id"], name: "index_hobbies_lists_on_hobbie_id"
    t.index ["user_id"], name: "index_hobbies_lists_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_suggestions_on_chat_id"
    t.index ["job_id"], name: "index_suggestions_on_job_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "age"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "goal"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "school_level"
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "hobbies_lists", "hobbies", column: "hobbie_id"
  add_foreign_key "hobbies_lists", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "suggestions", "chats"
  add_foreign_key "suggestions", "jobs"
end
