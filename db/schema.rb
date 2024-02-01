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

ActiveRecord::Schema[7.1].define(version: 2024_01_30_193459) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "picture"
    t.string "speciality"
    t.string "email"
    t.string "phone"
    t.time "starting_shift"
    t.time "ending_shift"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_doctors_on_created_by_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "day_of_month"
    t.string "day_of_week"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "month"
    t.bigint "user_id", null: false
    t.bigint "doctor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_reservations_on_doctor_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.string "role"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "doctors", "users", column: "created_by_id"
  add_foreign_key "reservations", "doctors"
  add_foreign_key "reservations", "users"
end
