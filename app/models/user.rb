class User < ApplicationRecord
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable,
         :lockable, :omniauthable, omniauth_providers: [:google_oauth2]

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

  def self.from_omniauth auth
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
