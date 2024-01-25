# frozen_string_literal: true

# app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController
  def create
    @doctor = Doctor.find(params[:doctor_id])
    @available_slots = @doctor.filter_available_slots

    # Assuming params contain user input for reservation
    reservation_params = params.require(:reservation).permit(:start_time, :end_time, :day_of_month, :day_of_week,
                                                             :month)

    if slot_available?(@available_slots, reservation_params)
      # Proceed with creating the reservation
      proposed_slot = @doctor.build_time_slot_rev(reservation_params[:start_time], reservation_params[:end_time],
                                                  reservation_params[:day_of_month], reservation_params[:day_of_week],
                                                  reservation_params[:month])

      @reservation = @doctor.reservations.create(proposed_slot)
      redirect_to @doctor, notice: 'Reservation successfully created.'
    else
      # Slot is not available, show error message or handle as needed
      redirect_to @doctor, alert: 'Selected slot is not available.'
    end
  end

  private

  def slot_available?(available_slots, reservation_params)
    proposed_slot = @doctor.build_time_slot_rev(reservation_params[:start_time], reservation_params[:end_time],
                                                reservation_params[:day_of_month], reservation_params[:day_of_week],
                                                reservation_params[:month])

    available_slots.any? { |slot| slot == proposed_slot }
  end

  def reservations_with_doctors
    @reservations_with_doctors = Reservation.reservations_with_doctors
    render json: @reservations_with_doctors
  end
end
