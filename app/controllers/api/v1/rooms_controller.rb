class Api::V1::RoomsController < ApplicationController
  before_action :authorize_request
  before_action :find_room, only: %i(show)

  def index
    @pagy, @rooms = pagy Room.room_order
                             .by_description(params[:description]),
                         items: Settings.room.room_per_page
    render json: @rooms
  end

  def show
    render json: @room
  end

  private

  def find_room
    @room = Room.find_by(id: params[:id])

    return if @room

    render json: {error: I18n.t("api.v1.cannot_found")}, status: :not_found
  end
end
