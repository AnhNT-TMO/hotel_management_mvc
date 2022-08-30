class Admin::BookingsController < Admin::AdminController
  before_action :load_booking, only: %i(edit update)
  after_action :send_mail, only: %i(update)

  def index
    @pagy, @bookings = pagy Booking.by_bills(params[:bill_id])
                                   .check_exist_booking(params[:start_date],
                                                        params[:end_date]),
                            items: Settings.bookings.booking_per_page
    bill = Bill.find_by(id: @bookings.first.bill_id)
    @total = bill.total_price
  end

  def edit; end

  def update
    @booking.status = Booking.statuses[:abort]
    if @booking.update(booking_params)
      flash[:success] = t ".update_success"
      redirect_to admin_bills_path
    else
      render :edit
      flash[:danger] = t ".update_fail"
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:reason, :status)
  end

  def load_booking
    @booking = Booking.find_by id: params[:id]
    return if @booking

    flash[:danger] = t ".load_booking_failed"
    redirect_to admin_dashboard_index_path
  end

  def send_mail
    SendBillMailer.send_booking_mail(@booking).deliver_later if @booking.abort?
  end
end
