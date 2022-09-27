class TopTrumpsController < ApplicationController

  before_action :authenticate_user!

  def show
    @top_trump = TopTrump.find(params[:id])
    @moves = @top_trump.current_trick_moves current_user
  end

  def index
  end

  def create
    @top_trump = TopTrump.new(state: 1)
    @top_trump.save
    redirect_to @top_trump, notice: "Game started"
  end

end
