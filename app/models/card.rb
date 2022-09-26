class Card < ApplicationRecord

  has_many :card_categories

  attr_accessor :face_up

  def face_up?
    @face_up
  end

end
