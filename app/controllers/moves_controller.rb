class MovesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_top_trump

  def create
    @move = Move.new(params.require(:move).permit(:card_category_id))
    @move.top_trump = @top_trump
    @move.user = current_user

    if @move.save!
      redirect_to top_trump_path(@move.top_trump)
    else
      redirect_to top_trump_path(@move.top_trump), notice: "Error occurred"
      # render :new, status: :unprocessable_entity
    end
  end

  private

  def set_top_trump
    @top_trump = TopTrump.find(params[:top_trump_id])
  end

end
