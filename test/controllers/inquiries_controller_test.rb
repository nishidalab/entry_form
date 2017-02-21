require 'test_helper'

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  test "index should redirect to login when not logged in" do
    get inquire_path
    assert_redirected_to login_url
  end

  test "should get index login when logged in" do
    log_in_as_participant @participant
    get inquire_path
    assert_response :success
  end

  test "new should redirect to login when not logged in" do
    get inquire_new_path
    assert_redirected_to login_url
  end

  test "should new index login when logged in" do
    log_in_as_participant @participant
    get inquire_new_path
    assert_response :success
  end

end
