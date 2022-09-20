module ApplicationHelper
  include Pagy::Frontend
  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = "error" if type == "danger"
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text if message
    end
    flash_messages.join("\n")
  end

  def change_money money
    I18n.locale == I18n.default_locale ? money : money / Settings.room.usd
  end

  def status_color status
    if status == "pending"
      "text-primary"
    else
      status == "confirm" ? "text-success" : "text-danger"
    end
  end

  def alert_flash_now message
    flash.now[:danger] = message
  end
end
