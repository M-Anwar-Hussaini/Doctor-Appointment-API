# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :doctor
  belongs_to :user

  # Add any additional validations as needed
  validates :day_of_month, presence: true
  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :month, presence: true

  # Method to retrieve reservations made by a specific user
  def self.reservations_by_user(user_id)
    where(user_id: user_id).map do |reservation|
      doctor_namee = reservation.doctor.name
      {
        reservation_id: reservation.id,
        doctor_name: doctor_namee,
        reservation_time: reservation.start_time,
        day_of_week: reservation.day_of_week,
        month: reservation.month,
        day_of_month: reservation.day_of_month,
        created_at_formatted: reservation.created_at.strftime('%B %d, %Y %H:%M')
      }
    end
  end

  # Add any custom methods or validations related to reservations
  def self.reservations_with_doctors_and_users
    includes(:doctor, :user).map do |reservation|
      doctor_namee = Doctor.find_by(id: reservation.doctor_id)&.name
      user_name = User.find_by(id: reservation.user_id)&.firstname

      {
        reservation_id: reservation.id,
        doctor_name: doctor_namee,
        booking_user_name: user_name,
        reservation_time: reservation.start_time,
        day_of_week: reservation.day_of_week,
        month: reservation.month,
        day_of_month: reservation.day_of_month,
        created_at_formatted: reservation.created_at.strftime('%B %d, %Y %H:%M')
      }
    end
  end
end
