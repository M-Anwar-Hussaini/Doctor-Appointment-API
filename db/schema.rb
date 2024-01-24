# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_240_124_121_233) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'doctors', force: :cascade do |t|
    t.string 'name'
    t.string 'picture'
    t.string 'speciality'
    t.string 'email'
    t.string 'phone'
    t.time 'starting_shift'
    t.time 'ending_shift'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'reservations', force: :cascade do |t|
    t.bigint 'doctor_id'
    t.integer 'day_of_month'
    t.string 'day_of_week'
    t.integer 'time_booked'
    t.integer 'month'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['doctor_id'], name: 'index_reservations_on_doctor_id'
  end

  add_foreign_key 'reservations', 'doctors'
end
