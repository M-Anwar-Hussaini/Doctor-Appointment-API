class User < ApplicationRecord
  has_secure_password

  has_many :reservations
  has_many :doctors, foreign_key: :created_by_id

  validates :firstname, :lastname, :role, :email, presence: true

  # Custom error message for presence validation
  validates :email, presence: { message: "Email can't be blank" }

  validates :email, uniqueness: { message: 'Email has already been taken' }

  # Custom error message for format validation
  #   validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email format is invalid' }

  validates :password, presence: { message: "Password can't be blank" }

  # Custom error message for length validation
  validates :password, length: { minimum: 6, message: 'Password is too short (minimum is 6 characters)' }

  def can_create_doctors?
    role == 'admin' # Adjust the condition based on your roles
  end

  def can_destroy_doctors?
    role == 'admin' # Adjust the condition based on your roles
  end

  def reservations_created_under_doctors
    Reservation.where(doctor_id: doctors.pluck(:id))
  end
end
