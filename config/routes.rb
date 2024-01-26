# frozen_string_literal: true

# config/routes.rb
Rails.application.routes.draw do
  get 'reservations/create' # This line is not necessary if you are using RESTful routes
  resources :doctors do
    resources :reservations, only: %i[index create] # Restrict reservations routes to only index and create actions
    # Define a custom route for available slots, using the doctor's ID directly
    get 'available_slots', to: 'doctors#available_slots', on: :member
  end

  get 'reservations_with_doctors', to: 'reservations#reservations_with_doctors' # Define a route for reservations with doctors

  # Define other routes as needed

  # Reveal health status route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Define the root path route
  # root "posts#index"
end
