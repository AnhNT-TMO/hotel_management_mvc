class Admin::BillsController < Admin::AdminController
  before_action :load_bill, only: %i(edit update)
  after_action :send_mail, only: %i(update)
  def index
    @pagy, @bills = pagy Bill.by_status(params[:status])
                             .search_by_key(params[:key])
                             .recent_bills,
                         items: Settings.bills.bill_per_page
  end

  def edit; end

  def update
    ActiveRecord::Base.transaction do
      @bill.update(bill_params)
      update_booking(@bill.id)
      flash[:success] = t ".update_success"
      redirect_to admin_bills_path
    end
  rescue StandardError => e
    flash[:danger] = e
    redirect_to admin_bills_path
  end

  private
  def load_bill
    @bill = Bill.find_by id: params[:id]
    return if @bill

    flash[:danger] = t ".load_room_failed"
    redirect_to admin_bills_path
  end

  def bill_params
    params.require(:bill).permit(:status)
  end

  def update_booking bill_id
    @bookings = Booking.by_bills(bill_id).checking
    @bookings.update status: Booking.statuses[:confirm]
  end

  def send_mail
    SendBillMailer.send_bill_mail(@bill).deliver_later if @bill.confirm?
  end
end
