class BasketsController < ApplicationController
  before_action :authenticate_user!, :find_bill, :filter_booking, only: :show
  before_action :authenticate_user!, :find_bookings_selected,
                :check_blank_selected, only: :destroy
  authorize_resource class: false

  def show; end

  def destroy
    if Booking.where(id: @bookings).pending.destroy_all.present?
      flash[:success] = t ".booking_delete_success"
    else
      flash[:danger] = t ".room_request_denied"
    end

    redirect_to baskets_path
  end

  private

  def check_blank_selected
    return if @bookings.present?

    flash[:danger] = t ".blank_selected"
    redirect_to baskets_path
  end

  def find_bookings_selected
    @bookings = []
    (1..3).each do |index|
      if !params["checkbox_#{index}"].nil? &&
         params["checkbox_#{index}"][:result] == "1"
        @bookings << params["booking_id_#{index}"]
      end
    end
    @bookings
  end

  def filter_booking
    @pagy, @bookings = pagy Booking.by_bills(@bill.id)
                                   .booking_order,
                            items: Settings.booking.booking_per_page,
                            link_extra: 'data-remote="true"'
  end

  def find_bill
    @bill = Bill.pending.by_current_user(current_user.id).first
    return if @bill

    @bill = current_user.bills.build
    return if @bill.save

    flash[:danger] = t ".danger_save_bill"
    redirect_to root_path
  end
end
