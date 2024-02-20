class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[create index]
  before_action :set_user, only: %i[show update destroy]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  def reservations_created_under_doctors_by_a_user
    user = User.find(params[:id])
    user_reservations = Reservation.reservations_by_user(user.id)
    render json: user_reservations
  end

  # GET /users/:id/reservations_created_under_doctors
  def reservations_created_under_doctors
    @user = User.find(params[:id])
    @reservations = @user.reservations_created_under_doctors
    render json: @reservations
  end

  # POST /users
  def create
    Rails.logger.debug("User Params: #{user_params.inspect}")
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      Rails.logger.debug("User Errors: #{@user.errors}")
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:firstname, :lastname, :role, :email, :password)
  end
end