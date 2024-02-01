# app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController
  def index
    @doctor = Doctor.find(params[:doctor_id])
    @reservations = @doctor.reservations
    render json: @reservations
  end

  def reservations_with_doctors
    @reservations_with_doctors = Reservation.reservations_with_doctors
    render json: @reservations_with_doctors
  end

  def create
    @doctor = Doctor.find(params[:doctor_id])
    @available_slots = @doctor.filter_available_slots

    # Debug statement
    Rails.logger.debug("Available Slots: #{@available_slots}")

    # Assuming params contain user input for reservation
    reservation_params = params.require(:reservation).permit(:start_time, :end_time, :day_of_month, :day_of_week,
                                                             :month)

    # Debug statement
    Rails.logger.debug("Reservation Params: #{reservation_params}")

    if slot_available?(@available_slots, reservation_params)

      @reservation = @doctor.reservations.create(
        day_of_month: reservation_params[:day_of_month],
        day_of_week: reservation_params[:day_of_week],
        time_booked: reservation_params[:start_time],
        month: reservation_params[:month]
      )

      render json: @reservation, status: :created
    else
      # Slot is not available, show error message or handle as needed
      render json: { error: 'Selected slot is not available.' }, status: :unprocessable_entity
    end
  end

  private

  def slot_available?(available_slots, reservation_params)
    proposed_start_time = @doctor.format_time_slots(reservation_params[:start_time])
    proposed_end_time = @doctor.format_time_slots(reservation_params[:end_time])
    proposed_slot = @doctor.build_time_slot_rev(proposed_start_time, proposed_end_time,
                                                reservation_params[:day_of_month], reservation_params[:day_of_week],
                                                reservation_params[:month])

    Rails.logger.debug("Proposed Slot: #{proposed_slot}")
    Rails.logger.debug("Available Slots: #{available_slots}")

    result = available_slots.any? { |slot| slot == proposed_slot }

    Rails.logger.debug("Slot Available Result: #{result}")

    result
  end
end
