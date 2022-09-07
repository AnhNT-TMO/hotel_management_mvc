class HistoriesController < ApplicationController
  before_action :logged_in_user, :check_exists_bill, :find_bill, only: :show

  def show; end

  private

  def find_bill
    @pagy, @bills = pagy Bill.by_current_user(current_user.id)
                             .find_bill_was_payment,
                         items: Settings.history.history_per_page
    return if @bills

    flash[:danger] = t ".alert_history"
    redirect_to root_path
  end

  def check_exists_bill
    return if current_user.bills.find_bill_was_payment.present?

    flash[:danger] = t ".bill_not_exists"
    redirect_to root_path
  end
end
