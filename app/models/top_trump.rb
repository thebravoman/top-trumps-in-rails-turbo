# https://playingcarddecks.com/blogs/all-in/terms-you-should-know-about-playing-cards-and-card-games#:~:text=in%20your%20hand.-,Hand.,until%20they%20are%20all%20played.
#
class TopTrump < ApplicationRecord

  has_many :moves
  has_many :accepts
  has_many :initial_hands, class_name: "Hand"

  # Need player1, player2 and lead because players join
  # and then the lead is determined on random
  #
  # It is not determined by who plays first
  belongs_to :player1, class_name: "User"
  # Player
  belongs_to :player2, class_name: "User", optional: true
  belongs_to :lead, class_name: "User", optional: true

  # These are optional and if set will
  # be set as the initial cards.
  # Otherwize they will be random.
  # This allows for injection of the cards which is good
  attr_accessor :cards_for_hand1
  attr_accessor :cards_for_hand2

  after_create :initialize_hands

  before_update :choose_lead

  def choose_lead
    if self.player2_id_change.try(:first)==nil
      self.lead = [player1, player2][rand(0..2)]
    end
  end


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

  def non_lead
    [player1, player2].select {|u| u != lead}.first
  end

  def current_trick_moves
    if self.lead == nil
      return []
    end
    hands = current_trick_hands
    leader_cards = hands.first.cards
    non_leader_cards = hands.second.cards
    # 1. [move not persisted, nil]
    # 2. Then move is created and we return [move persisted without card_category_id, nil]
    # 3. Then card_category is selected and we return [move persisted with card_category_id, move not persisted]
    # 4. Then second player creates a move [move persisted with card_category_id, move persisted without card_category_id]
    # and this automatically makes the score
    result = moves.where(trick: current_trick).order(:created_at).to_a
    if result ==[] # 1
      # Player 1 must draw a card
      [Move.new(user: lead, trick: current_trick, card: leader_cards.first), nil]
    elsif result.size == 1 && result[0].card_category == nil # 2
      # Player 1 must choose a category
      [result[0], nil]
    elsif result.size == 1 && result[0].card_category != nil # 3
      autoselected_card_category = non_leader_cards.first.card_categories.where(category: result[0].card_category.category).first
      # On draw The card already has the category so there is no need to update the category after that
      non_leader_play = Move.new(top_trump: self,
        user: non_lead,
        trick: current_trick,
        card: non_leader_cards.first,
        card_category: autoselected_card_category)
      [result[0], non_leader_play]
    elsif result.size == 2 && result[1].card_category != nil #
      # Player 2 must choose a category
      result
    else
      # Winnder is
      result
    end
  end

  # Current hand is all the cards the player has including the moved one
  def current_trick_hands
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
    [Hand.new(top_trump: self, cards: hand1_cards), Hand.new(top_trump: self, cards: hand2_cards)]
  end

  def top_card user
    hand1_cards = self.current_trick_hands.first.cards
    hand2_cards = self.current_trick_hands.second.cards

    selected_card = if user == self.player_1 || self.player_1 == nil
      hand1_cards.first
    else
      hand2_cards.first
    end
    selected_card
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
