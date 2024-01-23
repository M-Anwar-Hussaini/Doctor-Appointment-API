module Api
  class UsersController < ApplicationController
    def get_users
      @users = User.all
      render json: @users
    end
  end
end
