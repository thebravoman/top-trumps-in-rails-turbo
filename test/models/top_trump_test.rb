require "test_helper"

class TopTrumpTest < ActiveSupport::TestCase

  test "#name" do
    top_trump = top_trumps(:one)
    player1 = users(:player1)

    assert_equal top_trump.player1, player1
    assert_equal top_trump.name, "#{top_trump.id} - #{player1.name}"
  end

  test "first moves for trick are a Move to be created and nil" do
    top_trump = TopTrump.create(state: 1, player1: users(:player1))
    current_trick_moves = top_trump.current_trick_moves(users(:player1))
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == false
    assert current_trick_moves[1] == nil
  end

  test "after first draw moves are [Player1: Move to be updated, Player2: nil]" do
    player1 = users(:player1)
    top_trump = TopTrump.create(state: 1, player1: player1)
    Move.create!(top_trump: top_trump, user: player1, trick: top_trump.current_trick, card: Card.first)

    current_trick_moves = top_trump.current_trick_moves(player1)
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == true
    assert current_trick_moves[1] == nil
  end

  test "after choosing a category moves are [Player1: Move with set category, Player2: Move to be created]" do
    player1 = users(:player1)
    top_trump = TopTrump.create(state: 1, player1: player1)
    move = Move.create!(top_trump: top_trump, user: player1, trick: top_trump.current_trick, card: Card.first)
    move.update(card_category: Card.first.card_categories.first)

    current_trick_moves = top_trump.current_trick_moves(player1)
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == true
    assert current_trick_moves[0].card_category == Card.first.card_categories.first
    assert current_trick_moves[1].persisted? == false
    assert current_trick_moves[1].user == nil
  end

  test "after choosing a category player2 sees [Player1: Move to be updated, Player2: Move to be created(for them)]" do
    player1 = users(:player1)
    top_trump = TopTrump.create(state: 1, player1: player1)
    player2 = users(:player2)
    player1_card = top_trump.current_trick_hands.first.cards.first
    move = Move.create!(top_trump: top_trump, user: player1, trick: top_trump.current_trick, card: player1_card)
    move.update(card_category: player1_card.card_categories.where(category: categories(:loved)).first)

    current_trick_moves = top_trump.current_trick_moves(player2)
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == true
    assert_equal categories(:loved), current_trick_moves[0].card_category.category
    assert current_trick_moves[1].persisted? == false
    assert_equal categories(:loved), current_trick_moves[1].card_category.category
    assert_equal player2, current_trick_moves[1].user
  end

  test "initial hands are random and contain equal number of cards" do
    top_trump = TopTrump.create(state: 1, player1: users(:player1))
    assert_equal 2, top_trump.initial_hands.count
    assert_equal 2, top_trump.initial_hands.where(index: 1).first.cards.count
    assert_equal 2, top_trump.initial_hands.where(index: 2).first.cards.count
  end

  test "TopTrump can be initialized with cards for each player" do
    top_trump = TopTrump.create(
      state: 1,
      player1: users(:player1),
      cards_for_hand1: [cards(:javascript), cards(:python)],
      cards_for_hand2: [cards(:sql), cards(:ruby)]
    )
    assert_equal cards(:javascript), top_trump.initial_hands.where(index: 1).first.card_to_hands.first.card
    assert_equal cards(:python), top_trump.initial_hands.where(index: 1).first.card_to_hands.last.card

    assert_equal cards(:sql), top_trump.initial_hands.where(index: 2).first.card_to_hands.first.card
    assert_equal cards(:ruby), top_trump.initial_hands.where(index: 2).first.card_to_hands.last.card
  end

  test "after a move, hands contain won and lost cards" do
    top_trump = TopTrump.create(
      state: 1,
      player1: users(:player1),
      cards_for_hand1: [cards(:javascript), cards(:python)],
      cards_for_hand2: [cards(:sql), cards(:ruby)])

    Move.create!(
      top_trump: top_trump,
      user: users(:player1),
      trick: top_trump.current_trick,
      card: cards(:javascript),
      card_category: card_categories(:javascript_used)
    )

    Move.create!(
      top_trump: top_trump,
      user: users(:player2),
      trick: top_trump.current_trick,
      card: cards(:sql),
      card_category: card_categories(:sql_used)
    )

    assert_equal [cards(:python), cards(:javascript), cards(:sql)], top_trump.current_trick_hands.first.cards.to_a
    assert_equal [cards(:ruby)], top_trump.current_trick_hands.second.cards.to_a

  end

  test "after a move, and accepts, trick is updated" do
    top_trump = TopTrump.create(
      state: 1,
      player1: users(:player1),
      cards_for_hand1: [cards(:javascript), cards(:python)],
      cards_for_hand2: [cards(:sql), cards(:ruby)]
    )

    Move.create!(
      top_trump: top_trump,
      user: users(:player1),
      trick: top_trump.current_trick,
      card: cards(:javascript),
      card_category: card_categories(:javascript_used)
    )

    Move.create!(
      top_trump: top_trump,
      user: users(:player2),
      trick: top_trump.current_trick,
      card: cards(:sql),
      card_category: card_categories(:sql_used)
    )

    Accept.create!(
      top_trump: top_trump,
      user: users(:player1),
      trick: top_trump.current_trick
    )

    top_trump.reload
    assert_equal 1, top_trump.current_trick

    Accept.create!(
      top_trump: top_trump,
      user: users(:player2),
      trick: top_trump.current_trick
    )

    top_trump.reload
    assert_equal 2, top_trump.current_trick

  end

end
