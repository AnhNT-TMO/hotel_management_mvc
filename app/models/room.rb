class Room < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, reject_if: :all_blank,
                                 allow_destroy: true

  validates :name, :price, :types, presence: true

  scope :room_order, ->{order(id: :asc)}
  scope :by_rating, ->(rating){where("rate_avg = ?", rating)}
  scope :recent_rooms, ->{order(created_at: :desc)}
  scope :by_description,
        (lambda do |description|
          if description.present?
            where("description LIKE ?", "%#{description}%")
          end
        end)
  scope :by_between_date,
        (lambda do |start_date, end_date, user_id|
          left_joins(:bookings)
          .select("room_id")
          .where("bookings.end_date > :start_date
                  AND bookings.start_date < :end_date
                  AND bookings.user_id = :user_id",
                 start_date: start_date, end_date: end_date, user_id: user_id)
        end)

  scope :not_ids, ->(ids){where.not(id: ids)}
  scope :by_types, ->(types){where(types: types) if types.present?}

  def room_ids start_date, end_date, user_id
    @room_ids_checking = Booking.find_booking_was_not_pending
                                .check_exist_booking(
                                  start_date, end_date
                                ).pluck("room_id")
    @room_ids_pending = Room.by_between_date(start_date,
                                             end_date,
                                             user_id).pluck("room_id")
    @room_ids_checking + @room_ids_pending
  end
  enum types: {
    Single: 0,
    Double: 1,
    Queen: 2,
    King: 3
  }
end
