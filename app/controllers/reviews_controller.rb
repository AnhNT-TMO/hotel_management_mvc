class ReviewsController < ApplicationController
  before_action :authenticate_user!, :check_quantity_review,
                :check_star_review, only: :create
  def new; end

  def create
    @review = current_user.reviews.build review_params

    if @review.save
      save_rate_avg @review
      flash[:success] = t ".review_success"
    else
      flash[:danger] = t ".review_fail"
    end
    redirect_to room_path(id: @review.room_id)
  end

  private

  def save_rate_avg review
    @room = review.room
    @room.rate_avg = @room.reviews.average(:rating).to_f
    @room.save
  end

  def review_params
    params.require(:review).permit Review::REVIEW_PARAMS
  end

  def check_quantity_review
    return if Review.by_room_id(current_user.id,
                                params[:review][:room_id]).count <
              check_quantity_booking

    flash[:danger] = t ".quantity_review"
    redirect_to room_path(id: params[:review][:room_id])
  end

  def check_quantity_booking
    Booking.confirm.check_user_booking_confirm(
      current_user.id, params[:review][:room_id]
    ).count
  end

  def check_star_review
    if params[:review][:rating].to_i >= 1 && params[:review][:rating].to_i <= 5
      return
    end

    flash[:danger] = t ".danger_star_review"
    redirect_to room_path(id: params[:review][:room_id])
  end
end
