Rails.application.routes.draw do
  # Routes for doctors
  resources :doctors, only: [:index, :show, :create, :update, :destroy] do
    resources :reservations, only: [:index, :create]
    get 'available_slots', to: 'doctors#available_slots', on: :member
  end

  # Route to fetch reservations created under doctors by a specific user
  get '/users/:id/your_reservations', to: 'users#reservations_created_under_doctors_by_a_user', as: 'user_reservations'

  # Route to fetch all reservations with associated doctors
  get 'all_reservations', to: 'reservations#reservations_with_doctors'

  # Authentication routes
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # Signup route
  post '/signup', to: 'users#create'

  resources :users, only: [:index]
end
