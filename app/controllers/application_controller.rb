# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  require 'json_web_token'
  before_action :authorize_request

  private

  def authorize_request
    # Extract JWT token from Authorization header
    token = request.headers['Authorization']&.split&.last
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless token

    # Decode JWT token to get user ID
    user_id = JsonWebToken.decode(token)[:user_id]
    @current_user = User.find_by(id: user_id)

    # Check if user exists
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  rescue JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  attr_reader :current_user
end
