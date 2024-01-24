# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
# frozen_string_literal: true

# app/models/doctor.rb
class Doctor < ApplicationRecord
  has_many :reservations

  validate :valid_reservation_time, on: :create

  # ...

  # ...

  def available_time_slots_for_month
    available_time_ranges = []

    starting_time = parse_shift_time(starting_shift)
    ending_time = parse_shift_time(ending_shift)

    each_day_within_next_30_days do |date|
      day_start, day_end = calculate_day_bounds(date, starting_time, ending_time)

      iterate_through_shift_hours(day_start, day_end) do |hour|
        current_time = build_current_time_object(hour, date)

        unless overlapping_reservation?(current_time)
          start_time = format_time(hour)
          end_time = format_time(hour + 1.hour)

          available_time_ranges << build_time_slot(start_time, end_time, date)
        end
      end
    end

    available_time_ranges
  end

  private

  def parse_shift_time(shift)
    shift.is_a?(Time) ? shift : Time.parse(shift)
  end

  def each_day_within_next_30_days(&block)
    (Date.today..(Date.today + 30.days)).each(&block)
  end

  def calculate_day_bounds(date, starting_time, ending_time)
    day_start = Time.new(date.year, date.month, date.day, starting_time.hour, starting_time.min, starting_time.sec)
    day_end = Time.new(date.year, date.month, date.day, ending_time.hour, ending_time.min, ending_time.sec)
    [day_start, day_end]
  end

  def iterate_through_shift_hours(day_start, day_end, &block)
    (day_start.to_i...day_end.to_i).step(1.hour, &block)
  end

  def build_current_time_object(hour, date)
    {
      time_booked: hour,
      day_of_month: date.day,
      day_of_week: date.strftime('%A'),
      month: date.month
    }
  end

  def format_time(hour)
    Time.at(hour).strftime('%H:%M')
  end

  def build_time_slot(start_time, end_time, date)
    {
      start_time:,
      end_time:,
      day_of_month: date.day,
      day_of_week: date.strftime('%A'),
      month: Date::MONTHNAMES[date.month]
    }
  end

  def all_reservations
    reservations.order(:created_at) # Order by 'created_at' instead of 'time_booked'
  end

  def overlapping_reservation?(time)
    reservations.where(
      '(time_booked = ? AND day_of_month = ? AND day_of_week = ? AND month = ?)', time[:time_booked], time[:day_of_month], time[:day_of_week], time[:month]
    ).exists?
  end

  def invalid_time_range?(time)
    start_time = time[:time_booked]
    end_time = time[:time_booked] + 1.hour

    # Check if there is an existing reservation within the one-hour range
    reservations.where(
      'time_booked BETWEEN ? AND ? AND day_of_month = ? AND day_of_week = ? AND month = ?',
      start_time, end_time, time[:day_of_month], time[:day_of_week], time[:month]
    ).exists?
  end

  def weekday_shift?
    reservations.exists?(
      time_booked: starting_shift.to_i..ending_shift.to_i,
      created_at: 1.month.from_now.beginning_of_month..Time.current.end_of_month
    )
  end

#   def valid_reservation_time
#     if weekday_shift? && overlapping_reservation?({
#                                                     time_booked: starting_shift.to_i,
#                                                     day_of_month: Date.today.day,
#                                                     day_of_week: Date.today.strftime('%A'),
#                                                     month: Date.today.month
#                                                   })
#       errors.add(:base, 'Doctor is already reserved during this time on this day')
#     end

#     return unless weekday_shift? && invalid_time_range?({
#                                                           time_booked: starting_shift.to_i,
#                                                           day_of_month: Date.today.day,
#                                                           day_of_week: Date.today.strftime('%A'),
#                                                           month: Date.today.month
#                                                         })

#     errors.add(:base, 'Reservation time range must be one hour')

#     # Check if the reservation is more than a month ahead
#     return unless starting_shift.to_i > 1.month.from_now.to_i

#     errors.add(:base, 'Reservations cannot be made more than a month ahead')
#   end
end

# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
