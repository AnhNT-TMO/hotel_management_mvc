class PaymentController < ApplicationController
  before_action :authenticate_user!, :find_bill_pending, :find_bookings,
                :check_booking, :calculate_price, only: :create

  def create
    Bill.transaction do
      calculate_price
      fill_date_bill
      flash[:success] = t ".success_payment"
      redirect_to history_path
    end
  rescue StandardError => e
    flash[:danger] = e
    redirect_to baskets_path
  end

  private

  def calculate_price
    @bill.total_price = 0
    @bookings.each do |booking|
      @bill.total_price += booking.total_price
    end
  end

  def fill_date_bill
    @bill.status = Bill.statuses[:checking]
    @bill.bookings.update status: Booking.statuses[:checking]
    @bill.save!
    @new_bill = current_user.bills.build
    @new_bill.save!
  end

  def check_booking
    @bookings.each do |booking|
      @room_ids = Booking.checking
                         .check_exist_booking(booking.start_date,
                                              booking.end_date).pluck("room_id")
      next if Booking.find_room_with_id(@room_ids).blank?

      booking.destroy
      flash[:error] = t(".error_payment")
      @is_exists = true
    end
    redirect_to root_path if @is_exists
  end

  def find_bill_pending
    @bill = Bill.pending.by_current_user(current_user.id).first
    return if @bill

    @bill = current_user.bills.build
    return if @bill.save

    flash[:danger] = t ".danger_save_bill"
    redirect_to root_path
  end

  def find_bookings
    @bookings = Booking.by_bills(params[:bill][:bill_id])
    return if @bookings.first.present?

    flash[:danger] = t ".alert_booking"
    redirect_to baskets_path
  end
end
