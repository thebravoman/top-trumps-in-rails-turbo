class AcceptsController < ApplicationController

  before_action :set_top_trump
  before_action :authenticate_user!

  def create
    @accept = Accept.create(user:current_user, top_trump: @top_trump, trick: @top_trump.current_trick)
    redirect_to top_trump_path(@top_trump), notice: "Player accepted"
  end

  private
  def set_top_trump
    @top_trump = TopTrump.find(params[:top_trump_id])
  end

end
