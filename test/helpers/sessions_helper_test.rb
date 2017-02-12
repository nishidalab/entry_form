require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @participant = participants(:test)
  end

  test "current_participant returns right participant when session is nil" do
    remember_participant(@participant)
    assert_equal @participant, current_participant
  end

  test "current_participant returns nil when remember_digest is wrong" do
    remember_participant(@participant)
    @participant.update_attribute(:remember_digest, Participant.digest(Participant.new_token))
    assert_nil current_participant
  end
end