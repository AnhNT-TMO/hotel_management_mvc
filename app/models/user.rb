class User < ApplicationRecord
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: {
    user: 0,
    admin: 1
  }

  UPDATABLE_ATTRS = %i(name email phone password password_confirmation).freeze

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

  validates :phone, presence: true
end
