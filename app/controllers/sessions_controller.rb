class SessionsController < ApplicationController
  require 'json_web_token'
  skip_before_action :authorize_request, only: %i[create]
  # POST /login
  def create
    user = User.find_by(email: params[:email])

    # Debug statements to inspect parameters
    Rails.logger.debug("Email: #{params[:email]}, Password: #{params[:password]}")

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      token = JsonWebToken.encode(user_id: user.id)
      render json: { message: 'Login successful', token: }, status: :ok
    else
      # Debug statement for authentication failure
      Rails.logger.debug("Authentication failed for email: #{params[:email]}")

      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    render json: { message: 'Logout successful' }, status: :ok
  end
end
