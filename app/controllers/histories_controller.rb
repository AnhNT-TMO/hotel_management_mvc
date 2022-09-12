class HistoriesController < ApplicationController
  before_action :authenticate_user!, :check_exists_bill, :find_bill, only: :show
  authorize_resource class: false

  def show
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  private

  def find_bill
    @search = Bill.ransack(params[:search])
    @search.sorts = ["total_price asc", "user_name asc"] if @search.sorts.empty?
    @pagy, @bills = pagy @search.result
                                .by_current_user(current_user.id)
                                .find_bill_was_payment,
                         items: Settings.history.history_per_page
  end

  def check_exists_bill
    return if current_user.bills.find_bill_was_payment.present?

    flash[:danger] = t ".bill_not_exists"
    redirect_to root_path
  end
end
