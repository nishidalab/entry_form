require 'test_helper'

class ParticipantsDeactivateTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  def deactivate
    delete deactivate_path
  end

  test "should redirect to login when not logged in" do
    deactivate
    assert_redirected_to login_url
  end

  test "get settings and deactivate" do
    log_in_as_participant @participant
    get settings_path
    if @participant.schedules.blank? && @participant.events.blank?
      assert_select "a[href=?]", deactivate_path
    else
      assert_select "a[href=?]", deactivate_path, false
    end
    deactivate
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_not is_logged_in_participant?
    @participant.reload
    assert @participant.deactivated
    get login_path
    assert flash.empty?
  end
end
