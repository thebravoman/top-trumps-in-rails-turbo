# https://playingcarddecks.com/blogs/all-in/terms-you-should-know-about-playing-cards-and-card-games#:~:text=in%20your%20hand.-,Hand.,until%20they%20are%20all%20played.
#
class TopTrump < ApplicationRecord

  has_many :moves
  has_many :accepts
  has_many :initial_hands, class_name: "Hand"

  # These are optional and if set will
  # be set as the initial cards.
  # Otherwize they will be random.
  # This allows for injection of the cards which is good
  attr_accessor :cards_for_hand1
  attr_accessor :cards_for_hand2

  after_create :initialize_hands

  def initialize_hands
    if self.cards_for_hand1 == nil || self.cards_for_hand2 == nil
      cards = Card.all.shuffle
      self.cards_for_hand1 = cards[0..cards.size/2-1]
      self.cards_for_hand2 = cards[cards.size/2..-1]
    end

    hand1 = Hand.create(top_trump: self, index: 1)
    self.cards_for_hand1.each do |card|
      hand1.cards << card
    end

    hand2 = Hand.create(top_trump: self, index: 2)
    self.cards_for_hand2.each do |card|
      hand2.cards << card
    end
  end

  def player_1
    moves.where(trick: 1).order(:created_at).first.try(:user)
  end

  def player_2
    moves.where(trick: 1).order(:created_at).second.try(:user)
  end

  def current_trick_moves current_user
    hands = current_hands
    player_1_cards = hands.first
    player_2_cards = hands.second
    # 1. [move not persisted, nil]
    # 2. Then move is created and we return [move persisted without card_category_id, nil]
    # 3. Then card_category is selected and we return [move persisted with card_category_id, move not persisted]
    # 4. Then second player creates a move [move persisted with card_category_id, move persisted without card_category_id]
    # and this automatically makes the score
    result = moves.where(trick: current_trick).order(:created_at).to_a
    if result ==[] # 1
      # Player 1 must draw a card
      [Move.new(user: current_user, trick: current_trick, card: player_1_cards.first), nil]
    elsif result.size == 1 && result[0].card_category == nil # 2
      # Player 1 must choose a category
      [result[0], nil]
    elsif result.size == 1 && result[0].card_category != nil # 3
      # Player 2 must draw a card

      # Check if there already is player 2
      the_user = player_2
      # if there isn't and the current player is not player 1 than make the current player player
      the_user = current_user if player_1 && player_1 != current_user
      autoselected_card_category = player_1_cards.first.card_categories.where(category: result[0].card_category.category).first
      # On draw The card already has the category so there is no need to update the category after that
      player_2_move = Move.new(top_trump: self,
        user: the_user,
        trick: current_trick,
        card: player_2_cards.first,
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

  # Current hand is all the cards the player has including the moved one
  def current_hands
    hand1_cards = initial_hands.where(index: 1).first.card_to_hands.to_a.map{ |cth| cth.card }
    hand2_cards = initial_hands.where(index: 2).first.card_to_hands.to_a.map{ |cth| cth.card }

    moves_for_now = moves.order(:created_at).to_a
    # Remove last move as it is still not decided
    moves_for_now.pop() if moves_for_now.size % 2 == 1
    moves_for_now.group_by { |move| move.trick }.values.each do |move1, move2|
      hand1_cards.delete(move1.card)
      hand2_cards.delete(move2.card)

      if move1.card_category.numeric_value > move2.card_category.numeric_value
        hand1_cards << move1.card
        hand1_cards << move2.card
      else
        hand2_cards << move1.card
        hand2_cards << move2.card
      end
    end
    [hand1_cards, hand2_cards]
  end

  def move user
    moves.where(trick: current_trick, user: user).first
  end

  def try_update_trick
    number_of_accepts = accepts.count

    if number_of_accepts % 2 == 0
      update(current_trick: current_trick+1)
    end
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
