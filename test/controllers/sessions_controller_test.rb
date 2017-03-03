require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @member = members(:one)
  end

  test "login page should have links" do
    get login_path
    assert_response :success
    assert_select "a[href=?]", reset_path
    assert_select "a[href=?]", register_path
  end

  test "redirect to mypage when logged in" do
    log_in_as_participant(@participant)
    get login_path
    assert_redirected_to mypage_url
    follow_redirect!
    assert_template 'participants/show'
  end

  test "member login page should have a link to member register page" do
    get member_login_path
    assert_response :success
    assert_select "a[href=?]", member_register_path
  end

  test "redirect to member mypage when logged in" do
    log_in_as_member(@member)
    get member_login_path
    assert_redirected_to member_mypage_url
    follow_redirect!
    assert_template 'members/show'
  end
end
