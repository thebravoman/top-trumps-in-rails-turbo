class TopTrump < ApplicationRecord

  has_many :moves

  # def player_1
  #   moves.where(trick: 1).order(:created_at).first.try(:user)
  # end

  # def player_2
  #   moves.where(trick: 1).order(:created_at).second.try(:user)
  # end

  def current_trick_moves current_user
    # 1. [move not persisted, nil]
    # 2. Then move is created and we return [move persisted without card_category_id, nil]
    # 3. Then card_category is selected and we return [move persisted with card_category_id, move not persisted]
    # 4. Then second player creates a move [move persisted with card_category_id, move persisted without card_category_id]
    # and this automatically makes the score
    result = moves.where(trick: current_trick).order(:created_at).to_a
    if result ==[] # 1
      [Move.new(user: current_user, trick: current_trick, card: Card.first), nil]
    elsif result.size == 1 && result[0].card_category == nil #2
      [result[0], nil]
    elsif result.size == 1 && result[0].card_category != nil #3
      [result[0], Move.new(user: current_user, trick: current_trick, card: Card.first)]
    else
      result
    end
  end

  def move user
    moves.where(trick: current_trick, user: user).first
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
