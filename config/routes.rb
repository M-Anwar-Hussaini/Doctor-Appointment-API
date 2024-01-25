# frozen_string_literal: true

# config/routes.rb
Rails.application.routes.draw do
  get 'reservations/create' # This line is not necessary if you are using RESTful routes
  resources :doctors do
    resources :reservations, only: [:create] # Define reservations routes nested under doctors
    get 'available_slots', to: 'doctors#available_slots' # Define a custom route for available slots
    get 'reservations_with_doctors', to: 'reservations#reservations_with_doctors' # Define a route for reservations with doctors
  end

  # Define other routes as needed

  # Reveal health status route
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Define the root path route
  # root "posts#index"
end
