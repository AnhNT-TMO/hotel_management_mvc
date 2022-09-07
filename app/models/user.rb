class User < ApplicationRecord
  enum role: {
    user: 0,
    admin: 1
  }

  UPDATABLE_ATTRS = %i(name password password_confirmation).freeze

  has_many :reviews, dependent: :destroy
  has_many :bills, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :name, presence: true,
  length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
  length: {
    minimum: Settings.user.email.min_length,
    maximum: Settings.user.email.max_length
  },
    format: {with: Settings.user.email.regex_format}

  validates :password, presence: true, length:
    {minimum: Settings.user.password.min_length}, if: :password

  validates :phone, presence: true

  has_secure_password
end
