class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[show update destroy]
  # before_action :authorize_admin, only: %i[create destroy]

  # GET /doctors
  def index
    @doctors = Doctor.all

    render json: @doctors
  end

  def new
    @doctor_id = params[:doctor_id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authorize_admin
    return if current_user&.admin?

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def available_slots
    @doctor = Doctor.find_by(params[:doctor_id])
    @available_slots = @doctor.filter_available_slots
    render json: @available_slots
  end

  # GET /doctors/1
  def show
    render json: @doctor
  end

  # POST /doctors
  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      render json: @doctor, status: :created, location: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doctors/1
  def update
    if @doctor.update(doctor_params)
      render json: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doctors/1
  def destroy
    @doctor = Doctor.find(params[:id])

    if current_user.role == 'admin'
      @doctor.destroy!
      redirect_to doctors_url, notice: 'Doctor was successfully destroyed.'
    else
      redirect_to doctors_url, alert: 'You do not have permission to delete this doctor.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:name, :picture, :speciality, :email, :phone, :starting_shift, :ending_shift)
  end
end
