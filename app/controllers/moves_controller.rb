class MovesController < ApplicationController

  def create
    @top_trump = TopTrump.find(params[:top_trump_id])
    @move = Move.new(params.require(:move).permit(:card_category_id))
    @move.top_trump = @top_trump
    @move.user = current_user
    @move.save!
    redirect_to top_trump_path(@move.top_trump)
  end

end
