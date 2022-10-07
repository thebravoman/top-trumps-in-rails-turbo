require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase

  test "starting a game of top trump" do
    visit "/"
    assert_text "Visit the Top Trump game by clicking here"

    click_on "here"

    assert_text "Log in"

    fill_in "user[email]", with: "player1@example.com"
    fill_in "user[password]", with: "password"

    click_on "Log in"

    click_on "Start a new game"

    last_game = TopTrump.last
    assert_equal page.current_path, top_trump_path(last_game)
  end
end
