class TopTrump < ApplicationRecord

  has_many :moves
  has_many :accepts

  def player_1
    moves.where(trick: 1).order(:created_at).first.try(:user)
  end

  def player_2
    moves.where(trick: 1).order(:created_at).second.try(:user)
  end

  def current_trick_moves current_user
    # 1. [move not persisted, nil]
    # 2. Then move is created and we return [move persisted without card_category_id, nil]
    # 3. Then card_category is selected and we return [move persisted with card_category_id, move not persisted]
    # 4. Then second player creates a move [move persisted with card_category_id, move persisted without card_category_id]
    # and this automatically makes the score
    result = moves.where(trick: current_trick).order(:created_at).to_a
    if result ==[] # 1
      # Player 1 must draw a card
      [Move.new(user: current_user, trick: current_trick, card: Card.first), nil]
    elsif result.size == 1 && result[0].card_category == nil # 2
      # Player 1 must choose a category
      [result[0], nil]
    elsif result.size == 1 && result[0].card_category != nil # 3
      # Player 2 must draw a card

      # Check if there already is player 2
      the_user = player_2
      # if there isn't and the current player is not player 1 than make the current player player
      the_user = current_user if player_1 && player_1 != current_user
      autoselected_card_category = Card.first.card_categories.where(category: result[0].card_category.category).first
      # On draw The card already has the category so there is no need to update the category after that
      player_2_move = Move.new(top_trump: self,
        user: the_user,
        trick: current_trick,
        card: Card.first,
        card_category: autoselected_card_category)
      [result[0], player_2_move]
    elsif result.size == 2 && result[1].card_category != nil #
      # Player 2 must choose a category
      result
    else
      # Winnder is
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
