class CardToHand < ApplicationRecord
  belongs_to :hand
  belongs_to :card
end
