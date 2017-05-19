require 'test_helper'

class ParticipantsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @deactivated_participant = participants(:three)
  end

  test "login with remembering" do
    log_in_as_participant @participant, remember_me: '1'
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as_participant @participant, remember_me: '0'
    assert_nil cookies['remember_token']
  end
end
