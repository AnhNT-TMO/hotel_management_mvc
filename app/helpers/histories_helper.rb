module HistoriesHelper
  def check_status_history status
    {
      pending: "chip info",
      checking: "chip warning",
      confirm: "chip primary",
      abort: "chip danger",
      paid: "chip info"
    }[status.to_sym]
  end
end
