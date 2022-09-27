class Move < ApplicationRecord
  belongs_to :card
  belongs_to :card_category, optional: true
  belongs_to :top_trump
  belongs_to :user

  after_create :update_top_trump_state

  private
  def update_top_trump_state
    top_trump.update_state
  end
end
