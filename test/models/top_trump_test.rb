require "test_helper"

class TopTrumpTest < ActiveSupport::TestCase

  test "first moves for trick are a Move to be created and nil" do
    top_trump = TopTrump.create(state: 1)
    current_trick_moves = top_trump.current_trick_moves(users(:player1))
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == false
    assert current_trick_moves[1] == nil
  end

  test "after first move return Move to be updated and nil" do
    top_trump = TopTrump.create(state: 1)
    player1 = users(:player1)
    Move.create!(top_trump: top_trump, user: player1, trick: top_trump.current_trick, card: Card.first)

    current_trick_moves = top_trump.current_trick_moves(player1)
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == true
    assert current_trick_moves[1] == nil
  end

  test "after choosing a category on first Move return Move to be updated and Move to be created" do
    top_trump = TopTrump.create(state: 1)
    player1 = users(:player1)
    Move.create!(top_trump: top_trump, user: player1, trick: top_trump.current_trick, card: Card.first)
    Move.update(card_category: Card.first.card_categories.first)

    current_trick_moves = top_trump.current_trick_moves(player1)
    assert current_trick_moves.size == 2
    assert current_trick_moves[0].persisted? == true
    assert current_trick_moves[0].card_category == Card.first.card_categories.first
    assert current_trick_moves[1].persisted? == false
  end



end
