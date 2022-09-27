class TopTrump < ApplicationRecord

  has_many :moves

  def card player
    if player == :player_1
      card = Card.first
      card.face_up = true
    else
      card = Card.second
      card.face_up = false
    end
    card
  end

  def state_message player
    if player == :player_1
      case state
      when 1
        "Player 1, pick a category"
      when 2
        "Waiting for Player 2"
      when 3
        "Player 1 wins trick"
      end
    else

    end

  end

  def update_state
    case state
    when 1
      update(state: state+1)
    end
  end

end
