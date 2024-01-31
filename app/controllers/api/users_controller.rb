module Api
  class UsersController < ApplicationController
    def all_users
      @users = User.all
      render json: @users
    end
  end
end
