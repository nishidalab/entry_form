require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @participant = participants(:one)
    @member = members(:one)
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

  test "current_member returns right member when session is nil" do
    remember_member(@member)
    assert_equal @member, current_member
  end

  test "current_member returns nil when remember_digest is wrong" do
    remember_member(@member)
    @member.update_attribute(:remember_digest, Member.digest(Member.new_token))
    assert_nil current_member
  end
end
