class TopTrumpsController < ApplicationController

  before_action :authenticate_user!

  def show
    @top_trump = TopTrump.find(params[:id])
    @move_player_1 = @top_trump.move @top_trump.player_1
    @move_player_2 = @top_trump.move @top_trump.player_2
  end

  def index
  end

  def create
    @top_trump = TopTrump.new(state: 1)
    @top_trump.moves << Move.new(card: Card.first, trick:1, user: current_user)
    @top_trump.save
    redirect_to @top_trump, notice: "Game started"
  end

end
