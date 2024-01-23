# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    get 'users/get_users'
  end
end
