require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#name" do
    assert_equal "player1", users(:player1).name
  end
end
