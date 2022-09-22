class RoomsController < ApplicationController
  before_action :find_rooms, only: :show
  before_action :check_blank_date, :check_date, only: :index
  load_and_authorize_resource

  def index
    if user_signed_in?
      filter_if_logged_in
      @start_date = params[:search][:start_date_cont]
      @end_date = params[:search][:end_date_cont]
    else
      filter_if_guest
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @review = Review.new
    @photo = @review.photos.build
    @list_review = @room.reviews.create_desc
  end

  private

  def filter_if_logged_in
    set_params_search
    @search = Room.ransack(params[:search],
                           auth_object: set_ransack_auth_object)
    @pagy, @rooms = pagy @search.result,
                         items: Settings.room.room_per_page,
                         link_extra: 'data-remote="true"'
    params[:description]
  end

  def set_params_search
    @room_ids = Room.new.room_ids(params[:search][:start_date_cont],
                                  params[:search][:end_date_cont],
                                  current_user.id)
    params[:search][:id_not_in] = @room_ids
  end

  def filter_if_guest
    @pagy, @rooms = pagy Room.room_order
                             .by_description(params[:search][:description]),
                         items: Settings.room.room_per_page,
                          link_extra: 'data-remote="true"'
  end

  def find_rooms
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:danger] = t ".can_not_find_room"
    redirect_to root_path
  end

  def check_date
    if params[:search][:start_date_cont] < params[:search][:end_date_cont]
      return
    end

    flash[:danger] = t ".date_danger"
    @pagy, @rooms = pagy Room.room_order, items: Settings.room.room_per_page
    redirect_to root_path
  end

  def init_date
    return unless params[:search].nil?

    params[:search] =
      {start_date_cont: DateTime.now.to_date,
       end_date_cont: Settings.day.day_from_now.days.from_now.to_date}
  end

  def check_blank_date
    init_date
    if params[:search][:start_date_cont].present? &&
       params[:search][:end_date_cont].present?
      nil
    end
  end

  def set_ransack_auth_object
    current_user.admin? ? :admin : :user
  end
end
