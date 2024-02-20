class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[show update destroy]
  before_action :authorize_request, only: %i[create destroy]

  # GET /doctors
  def index
    @doctors = Doctor.all

    render json: @doctors
  end

  def new
    @doctor_id = params[:doctor_id]
  end

  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id])
  # end

  # def authorize_admin
  #   return if current_user&.admin?

  #   redirect_to root_path, alert: 'You are not authorized to perform this action.'
  # end

  def available_slots
    @doctor = Doctor.find(params[:id])
    Rails.logger.debug "Doctor object: #{@doctor.inspect}"
    @available_slots = @doctor.filter_available_slots
    render json: @available_slots
  end

  # GET /doctors/1
  def show
    render json: @doctor
  end

  # POST /doctors
  def create
    if current_user && (current_user.role.downcase == 'admin')
      # Log the parameters being received
      Rails.logger.debug "Received parameters: #{params.inspect}"
    
      @doctor = Doctor.new(doctor_params)
      @doctor.created_by = current_user
    
      # Log the doctor_params method result
      Rails.logger.debug "doctor_params result: #{doctor_params.inspect}"
    
      # Parse starting_shift and ending_shift strings into Time objects
      starting_shift_param = doctor_params[:starting_shift]
      ending_shift_param = doctor_params[:ending_shift]
      Rails.logger.debug "Starting Shift Param: #{starting_shift_param}"
      Rails.logger.debug "Ending Shift Param: #{ending_shift_param}"
    
      @doctor.starting_shift = Time.parse(starting_shift_param) if starting_shift_param.present?
      @doctor.ending_shift = Time.parse(ending_shift_param) if ending_shift_param.present?
    
      if @doctor.save
        render json: @doctor, status: :created, location: @doctor
      else
        render json: @doctor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You do not have permission to create a doctor.' }, status: :unauthorized
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
      # redirect_to doctors_url, notice: 'Doctor was successfully destroyed.'
    else
      redirect_to doctors_url, alert: 'You do not have permission to delete this doctor.'
    end
  end

  def current_user
    token = request.headers['Authorization']&.split&.last
    return unless token

    decoded_token = JsonWebToken.decode(token)
    @current_user ||= User.find_by(id: decoded_token[:user_id])
  rescue JWT::DecodeError
    nil
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.require(:doctor).permit(:name, :picture, :speciality, :email, :phone, :starting_shift, :ending_shift)
  end

  def authorize_admin
    return if current_user && (current_user.role.downcase == 'admin')

    render json: { error: 'You do not have permission to perform this action.' }, status: :unauthorized
  end
end
