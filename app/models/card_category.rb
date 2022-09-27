class CardCategory < ApplicationRecord
  belongs_to :card
  belongs_to :category

  delegate :title, to: :category
end
