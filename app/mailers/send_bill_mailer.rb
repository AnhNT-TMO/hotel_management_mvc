class SendBillMailer < ApplicationMailer
  def send_bill_mail bill
    @bill = bill
    mail to: @bill.user_email, subject: t(".subject")
  end

  def send_booking_mail booking
    @booking = booking
    mail to: @booking.user_email, subject: t(".subject")
  end
end
