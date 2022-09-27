class TopTrumpsController < ApplicationController

  def show
    @top_trump = TopTrump.find(params[:id])
    @card_player_1 = @top_trump.card :player_1
    @card_player_2 = @top_trump.card :player_2
  end

  def index
  end

  def create
    @top_trump = TopTrump.new(state: 1)

    @top_trump.save
    redirect_to @top_trump, notice: "Game started"
  end

end
