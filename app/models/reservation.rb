# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :doctor

  # Add any additional validations as needed
  validates :day_of_month, presence: true
  validates :day_of_week, presence: true
  validates :time_booked, presence: true
  validates :month, presence: true

  # Add any custom methods or validations related to reservations
  def self.reservations_with_doctors
    includes(:doctor).map do |reservation|
      {
        reservation_id: reservation.id,
        doctor_name: reservation.doctor.name,
        reservation_time: reservation.time_booked,
        day_of_week: reservation.day_of_week,
        month: reservation.month,
        created_at_formatted: reservation.created_at.strftime('%B %d, %Y %H:%M:%S') # Format created_at timestamp
      }
    end
  end
end
