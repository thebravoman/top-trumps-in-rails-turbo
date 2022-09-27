class TopTrump < ApplicationRecord

  has_many :moves

  def player_1
    moves.where(trick: 1).order(:created_at).first.try(:user)
  end

  def player_2
    moves.where(trick: 1).order(:created_at).second.try(:user)
  end

  def move user
    if moves.where(trick: current_trick).empty?
      Move.create(card: Card.first, trick: current_trick, user: user)
    end
    move = moves.where(trick: current_trick, user: user).first
    move = move || Move.new(card: Card.first, trick: current_trick)
    move
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
