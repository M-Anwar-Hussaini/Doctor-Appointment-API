class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.date :date
      t.string :city
      t.text :description

      t.timestamps
    end
  end
end
