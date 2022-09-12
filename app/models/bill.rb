class Bill < ApplicationRecord
  CREATABLE_ATTR = %i(total_price user_id discount_id).freeze

  has_many :bookings, dependent: :destroy
  belongs_to :user

  ransack_alias :pc, :user_phone

  enum status: {
    pending: 0,
    checking: 1,
    confirm: 2,
    abort: 3,
    paid: 4
  }

  has_many :bookings, dependent: :destroy
  belongs_to :user

  delegate :name, :phone, :email, to: :user, prefix: :user
  scope :by_start_date,
        (lambda do |start_date|
          where("bills.created_at >= :start_date", start_date: start_date)
        end)
  scope :by_end_date,
        (lambda do |end_date|
          where("bills.created_at <= :end_date", end_date: end_date)
        end)
  scope :recent_bills, ->{order(created_at: :asc)}
  scope :by_status, ->(status){where(status: status) if status.present?}
  scope :search_by_key, (lambda do |key|
                           joins(:user)
                           .where("users.name LIKE ?", "%#{key}%")
                           .or(where("users.phone LIKE ?", "%#{key}%"))
                         end)
  scope :by_current_user, ->(user_id){where user_id: user_id}
  scope :find_bill_was_payment, ->{where.not(status: :pending)}
  scope :find_bill_with_booking, ->(bill_id){where id: bill_id}

  ransacker :created_at, type: :date do
    Arel.sql("date(bills.created_at)")
  end

  class << self
    def ransackable_scopes _auth_object = nil
      %i(by_start_date by_end_date)
    end
  end
end
