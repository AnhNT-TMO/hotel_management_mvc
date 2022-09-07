class BookingsController < ApplicationController
  before_action :logged_in_user, :check_date, :find_room, :check_exist_booking,
                :find_bill, :check_quantity_basket, :fill_params, only: :create
  before_action :logged_in_user, :find_booking,
                :check_status_booking, only: :destroy

  def create
    @booking = Booking.new booking_params
    if @booking.save
      flash[:success] = t ".room_request_success"
    else
      flash[:danger] = t ".room_request_denied"
    end
    redirect_to rooms_path
  end

  def destroy
    if @booking.destroy
      @booking.check_status_destroy
      flash[:success] = t(".booking_delete_success")
    else
      flash[:danger] = t(".booking_delete_denied")
    end
    redirect_to rooms_path
  end

  def index
    @pagy, @bookings = pagy Booking.by_bills(params[:bill_id])
                                   .booking_order,
                            items: Settings.booking.booking_per_page
  end

  private

  def booking_params
    params.require(:booking).permit(Booking::CREATABLE_ATTRS)
  end

  def find_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:danger] = t ".alert_booking"
    redirect_to root_path
  end

  def find_room
    @room = Room.find_by id: params[:booking][:room_id]
    return if @room

    flash[:danger] = t ".alert_room"
    redirect_to root_path
  end

  def find_bill
    @bill = Bill.pending.by_current_user(current_user.id).first
    return if @bill

    @bill = current_user.bills.build
    return if @bill.save

    flash[:danger] = t ".danger_save_bill"
    redirect_to root_path
  end

  def check_date
    init_date
    return if (params[:booking][:end_date].to_date -
          params[:booking][:start_date].to_date).to_i >= 1

    flash[:danger] = t ".alert_date_invalid"
    redirect_to root_path
  end

  def check_exist_booking
    @room_ids = find_room_ids_from_bookings
    return if Booking.find_room_with_id(@room.id)
                     .find_room_with_id(@room_ids).blank?

    flash[:danger] = t ".room_was_booking"
    redirect_to rooms_path
  end

  def find_room_ids_from_bookings
    Booking.booking_ids(params[:booking][:start_date],
                        params[:booking][:end_date],
                        current_user.id)
  end

  def init_date
    params[:start_date] =
      params[:start_date].presence || DateTime.now.to_date
    params[:end_date] =
      params[:end_date].presence ||
      Settings.day.day_from_now.days.from_now.to_date
  end

  def fill_params
    @booking = current_user.bookings.build booking_params
    @booking.total_price = @booking.calculate_total_price(@room)
    @booking.bill_id = @bill.id
  end

  def check_quantity_basket
    return if @bill.bookings.count < Settings.basket.max_basket

    flash[:danger] = t ".basket_full"
    redirect_to rooms_path
  end

  def check_status_booking
    return if @booking.checking? || @booking.pending?

    flash[:danger] = t ".booking_was_checked"
    redirect_to history_path
  end
end
