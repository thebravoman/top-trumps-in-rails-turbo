class MovesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_top_trump

  def create
    @move = Move.create!({
      user: current_user,
      top_trump: @top_trump,
      trick: @top_trump.current_trick,
      card: @top_trump.top_card(current_user)}.merge(move_params)
    )

    redirect_to top_trump_path(@top_trump), notice: "Moved made successfully"
  end

  def update
    @move = Move.find(params[:id])
    if @move.update(move_params)
      redirect_to top_trump_path(@move.top_trump)
    else
      redirect_to top_trump_path(@move.top_trump), notice: "Error occurred"
      # render :new, status: :unprocessable_entity
    end
  end

  private

  def move_params
    params.require(:move).permit(:card_category_id)
  end

  def set_top_trump
    @top_trump = TopTrump.find(params[:top_trump_id])
  end

end
