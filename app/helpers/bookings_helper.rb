module BookingsHelper
  def check_status_booking status
    {
      pending: "chip info",
      checking: "chip warning",
      confirm: "chip primary",
      abort: "chip danger"
    }[status.to_sym]
  end
end
