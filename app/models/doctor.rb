# app/models/doctor.rb
class Doctor < ApplicationRecord
  has_many :reservations
  belongs_to :created_by, class_name: 'User'
  validates :name, presence: true
  validates :starting_shift, presence: true
  validates :ending_shift, presence: true

  def available_time_slots_for_month
    available_time_ranges = []
    # starting_time = parse_shift_time(starting_shift).strftime('%H:%M')
    # ending_time = parse_shift_time(ending_shift).strftime('%H:%M')
    starting_time = parse_shift_time(starting_shift)
    ending_time = parse_shift_time(ending_shift)
    Rails.logger.debug "Starting Shift: #{starting_time}"
    Rails.logger.debug "Ending Shift: #{ending_time}"

    each_day_within_next_30_days do |date|
      day_start, day_end = calculate_day_bounds(date, starting_time, ending_time)

      iterate_through_shift_hours(day_start, day_end) do |hour|
        Rails.logger.debug "Processing hour: #{hour}"
        # current_time = build_current_time_object(hour, date)
        # next if overlapping_reservation?(current_time)

        available_time_ranges << build_time_slot(format_time(hour), format_time(hour + 1.hour), date)
      end
    end

    available_time_ranges
  end

  def parse_shift_time(shift)
    shift.is_a?(Time) ? shift : Time.parse(shift)
  end

  def each_day_within_next_30_days()
    (Date.today.next_day..(Date.today + 30.days)).each do |date|
      Rails.logger.debug "Processing date: #{date}"
      yield(date)
    end
  end

  # def calculate_day_bounds(date, starting_time, ending_time)
  #   starting_time_obj = Time.parse(starting_time)
  #   ending_time_obj = Time.parse(ending_time)

  #   day_start = Time.new(date.year, date.month, date.day, starting_time_obj.hour, starting_time_obj.min,
  #                        starting_time_obj.sec)
  #   day_end = Time.new(date.year, date.month, date.day,
  # ending_time_obj.hour, ending_time_obj.min, ending_time_obj.sec)
  #   Rails.logger.debug "Processing date: #{date}"
  #   Rails.logger.debug "Day start time: #{day_start}, Day end time: #{day_end}"
  #   [day_start, day_end]
  # end

  def calculate_day_bounds(date, starting_time, ending_time)
    day_start = Time.new(date.year, date.month, date.day, starting_time.hour, starting_time.min, starting_time.sec)
    day_end = Time.new(date.year, date.month, date.day, ending_time.hour, ending_time.min, ending_time.sec)
    Rails.logger.debug "Day start time: #{day_start}, Day end time: #{day_end}"
    [day_start, day_end]
  end

  def iterate_through_shift_hours(day_start, day_end, &)
    (day_start.to_i...day_end.to_i).step(1.hour, &)
  end

  # def build_current_time_object(hour, date)
  #   {
  #     time_booked: hour,
  #     day_of_month: date.day,
  #     day_of_week: date.strftime('%A'),
  #     month: date.month
  #   }
  # end

  def format_time(hour)
    Time.at(hour).strftime('%H:%M')
  end

  def build_time_slot(start_time, end_time, date)
    Rails.logger.debug "Building time slot for #{date} - #{start_time} to #{end_time}"
    {
      start_time:,
      end_time:,
      day_of_month: date.day,
      day_of_week: date.strftime('%A'),
      month: Date::MONTHNAMES[date.month]
    }
  end

  # def overlapping_reservation?(time)
  #   start_time = time[:time_booked]
  #   end_time = start_time + 1.hour
  #   Rails.logger.debug "Checking overlapping reservation for time: #{start_time} to #{end_time}"

  #   reservations.where(
  #     'time_booked BETWEEN ? AND ? AND day_of_month = ? AND day_of_week = ? AND month = ?',
  #     start_time, end_time, time[:day_of_month], time[:day_of_week], time[:month]
  #   ).exists?
  # end

  def build_time_slot_rev(start_time, end_time, day_of_month, _day_of_week, month)
    # year = Date.current.year
    date = Date.new(Date.current.year, month, day_of_month)
    day_of_week_in_year = date.strftime('%A')
  
    Rails.logger.debug "Building time slot for: "
    Rails.logger.debug "Start Time: #{start_time}"
    Rails.logger.debug "End Time: #{end_time}"
    Rails.logger.debug "Day of Month: #{day_of_month}"
    Rails.logger.debug "Day of Week: #{day_of_week_in_year}"
    Rails.logger.debug "Month: #{MONTHS[month]}"
  
    {
      start_time: start_time,
      end_time: end_time,
      day_of_month: day_of_month,
      day_of_week: day_of_week_in_year,
      month: MONTHS[month]
    }
  end
  

  MONTHS = [nil, 'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'].freeze

  def format_time_slots(hour)
    "#{hour.to_s.rjust(2, '0')}:00"
  end

  def reservations_as_time_slots
    time_slots = []

    reservations.each do |reservation|
      start_time = reservation.start_time
      end_time = start_time + 1
      time_slots << build_time_slot_rev(format_time_slots(start_time),
                                        format_time_slots(end_time),
                                        reservation.day_of_month,
                                        reservation.day_of_week, reservation.month)
    end

    time_slots
  end

  def filter_available_slots
    available_slots = available_time_slots_for_month
    reserved_slots = reservations_as_time_slots

    available_slots.reject do |slot|
      reserved_slots.any? do |reserved_slot|
        reserved_slot.values_at(:start_time, :end_time, :day_of_month, :day_of_week,
                                :month) == slot.values_at(:start_time, :end_time, :day_of_month, :day_of_week, :month)
      end
    end
  end
end
