require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:test)
  end

  test "login page should have a link to register page" do
    get login_path
    assert_response :success
    assert_select "a[href=?]", register_path
  end

  test "redirect to mypage when logged in" do
    log_in_as_participant(@participant)
    get login_path
    assert_redirected_to mypage_url
    follow_redirect!
    assert_template 'participants/show'
  end
end
