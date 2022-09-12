class RoomsController < ApplicationController
  before_action :find_rooms, only: :show
  before_action :check_blank_date, :check_date, only: :index

  def index
    if user_signed_in?
      filter_if_logged_in
      @start_date = params[:start_date]
      @end_date = params[:end_date]
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
    @room_ids = Room.new.room_ids(params[:start_date],
                                  params[:end_date],
                                  current_user.id)
    @pagy, @rooms = pagy Room.not_ids(@room_ids)
                             .by_description(params[:description]),
                         items: Settings.room.room_per_page,
                         link_extra: 'data-remote="true"'
  end

  def filter_if_guest
    @pagy, @rooms = pagy Room.room_order
                             .by_description(params[:description]),
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
    return if params[:start_date] < params[:end_date]

    flash[:danger] = t ".date_danger"
    @pagy, @rooms = pagy Room.room_order, items: Settings.room.room_per_page
    redirect_to root_path
  end

  def init_date
    params[:start_date] =
      params[:start_date].presence || DateTime.now.to_date
    params[:end_date] =
      params[:end_date].presence ||
      Settings.day.day_from_now.days.from_now.to_date
  end

  def check_blank_date
    init_date
    return if params[:start_date].present? && params[:end_date].present?

    @pagy, @rooms = pagy Room.room_order, items: Settings.room.room_per_page
    render :index
  end
end
