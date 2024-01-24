# frozen_string_literal: true

class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :picture
      t.string :speciality
      t.string :email
      t.string :phone
      t.time :starting_shift
      t.time :ending_shift

      t.timestamps
    end
  end
end
