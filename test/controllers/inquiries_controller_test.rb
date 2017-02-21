require 'test_helper'

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @other = participants(:two)
    @inquiry = inquiries(:one)
  end

  test "index should redirect to login when not logged in" do
    get inquiries_path
    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    log_in_as_participant @participant
    get inquiries_path
    assert_select 'h3', count: @participant.inquiries.count
  end

  test "new should redirect to login when not logged in" do
    get inquiries_new_path
    assert_redirected_to login_url
  end

  test "should get new when logged in" do
    log_in_as_participant @participant
    get inquiries_new_path
    assert_response :success
  end

end
