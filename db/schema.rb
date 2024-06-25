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

ActiveRecord::Schema[7.1].define(version: 2024_06_21_170610) do
  create_table "books", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 3
    t.datetime "updated_at", precision: 3
    t.datetime "deleted_at", precision: 3
    t.text "title", size: :long, null: false
    t.text "author", size: :long
    t.bigint "edition", default: 1, unsigned: true
    t.text "publisher", size: :long
    t.date "publication_date"
    t.text "genre", size: :long
    t.bigint "available", unsigned: true
    t.bigint "total", unsigned: true
    t.index ["deleted_at"], name: "idx_books_deleted_at"
  end

  create_table "borrowing_records", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 3
    t.datetime "updated_at", precision: 3
    t.datetime "deleted_at", precision: 3
    t.bigint "book_id", unsigned: true
    t.bigint "user_id", unsigned: true
    t.date "date_of_issue"
    t.text "date_of_return", size: :long
    t.index ["deleted_at"], name: "idx_borrowing_records_deleted_at"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

end
