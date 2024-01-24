# frozen_string_literal: true

# app/models/reservation.rb
class Reservation < ApplicationRecord
  belongs_to :doctor

  # validate :valid_reservation_time, on: :create
  validates :time_booked, presence: true,
                          numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }

  # private

  # def valid_reservation_time
  #   if doctor.weekday_shift? && doctor.overlapping_reservation?(time_booked)
  #     errors.add(:base, 'Doctor is already reserved during this time on this day')
  #   end

  #   return unless doctor.weekday_shift? && doctor.invalid_time_range?(time_booked)

  #   errors.add(:base, 'Reservation time range must be one hour')

  #   # Check if the reservation is more than a month ahead
  #   return unless time_booked > 1.month.from_now

  #   errors.add(:base, 'Reservations cannot be made more than a month ahead')
  # end
end
