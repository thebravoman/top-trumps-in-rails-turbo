class TopTrumpsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_top_trump, only: [:show, :update]

  def show
    @moves = @top_trump.current_trick_moves
    @hands = @top_trump.current_trick_hands
  end

  def index

  end

  def update
    if @top_trump.update(top_trump_params)
      redirect_to top_trump_path(@top_trump), notice: "Player 2 joined the game"
    else
    end
  end


  def create
    @top_trump = TopTrump.new(state: 1, player1: current_user)
    @top_trump.save!
    redirect_to @top_trump, notice: "Game created and player 1 joined"
  end

  private
  def set_top_trump
    @top_trump = TopTrump.find(params[:id])
  end

  def top_trump_params
    params.require(:top_trump).permit(:player2_id)
  end

end
