class Admin::RoomsController < Admin::AdminController
  load_and_authorize_resource
  before_action :load_room, only: %i(edit update)

  def index
    @list_rooms_ability = @rooms.accessible_by(current_ability)
    @pagy, @rooms = pagy @rooms.recent_rooms.by_types(params[:types]),
                         items: Settings.room.room_per_page
  end

  def new
    @room = Room.new
    @image = @room.images.build
  end

  def edit; end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to admin_rooms_path
      flash[:success] = t ".alert"
    else
      flash[:danger] = t ".alert_not_save"
      render :new
    end
  end

  def update
    if @room.update(room_params)
      flash[:success] = t ".update_success"
      redirect_to admin_rooms_path
    else
      render :edit
      flash[:danger] = t ".update_fail"
    end
  end

  private
  def room_params
    params.require(:room).permit(:name, :description, :price, :types,
                                 images_attributes:
                                 [:id, :photo, :_destroy])
  end

  def load_room
    @room = Room.find_by id: params[:id]
    return if @room

    flash[:danger] = t ".load_room_failed"
    redirect_to admin_rooms_path
  end
end
