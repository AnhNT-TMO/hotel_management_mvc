class Admin::DashboardController < Admin::AdminController
  load_and_authorize_resource
  def index; end
end
