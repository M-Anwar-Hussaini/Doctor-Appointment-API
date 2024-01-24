# frozen_string_literal: true

# db/migrate/xxxxxx_create_reservations.rb
class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :doctor, foreign_key: true
      t.integer :day_of_month
      t.string :day_of_week
      t.integer :time_booked
      t.integer :month
      t.timestamps
    end
  end
end
