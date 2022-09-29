class Hand < ApplicationRecord
  has_many :card_to_hands
  has_many :cards, through: :card_to_hands
  belongs_to :top_trump
end
