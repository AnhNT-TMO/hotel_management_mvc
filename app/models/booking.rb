class Booking < ApplicationRecord
  CREATABLE_ATTRS = %i(room_id bill_id total_price start_date end_date).freeze

  belongs_to :user
  belongs_to :room
  belongs_to :bill

  enum status: {
    pending: 0,
    checking: 1,
    confirm: 2,
    abort: 3
  }

  belongs_to :user
  belongs_to :room
  belongs_to :bill

  delegate :name, :images, :rate_avg, :price, to: :room, prefix: :room
  delegate :name, :phone, :email, to: :user, prefix: :user

  scope :by_bills, ->(bill_id){where(bill_id: bill_id) if bill_id.present?}

  scope :recent_bookings, ->{order(created_at: :asc)}
  scope :booking_order, ->{order(id: :asc)}
  scope :find_booking, ->(user_id){where user_id: user_id}
  scope :check_exist_booking,
        (lambda do |start_date, end_date|
          if start_date.present? && end_date.present?
            where("end_date > :start_date AND start_date < :end_date",
                  start_date: start_date, end_date: end_date)
          end
        end)

  scope :find_room_with_id, ->(room_id){where room_id: room_id}
  scope :find_booking_with_bill_id, ->(bill_id){where bill_id: bill_id}

  def calculate_total_price booking, room
    (booking.end_date.to_date -
      booking.start_date.to_date).to_i * room.price
  end
  scope :check_user_booking_confirm,
        (lambda do |user_id, room_id|
          where(user_id: user_id, room_id: room_id)
        end)

  def booking_ids start_date, end_date, user_id
    @room_ids_checking = Booking.checking.check_exist_booking(
      start_date, end_date
    ).pluck("room_id")
    @room_ids_pending = Room.by_between_date(start_date,
                                             end_date,
                                             user_id).pluck("room_id")
    @room_ids_checking + @room_ids_pending
  end
end
