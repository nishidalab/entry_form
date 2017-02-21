require 'test_helper'

class ParticipantsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", mypage_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "login with valid information and logout" do
    get login_path
    log_in_as_participant @participant
    follow_redirect!
    assert_template 'applications/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", applications_path
    assert_select "a[href=?]", mypage_path
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_redirected_to login_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", applications_path, count: 0
    assert_select "a[href=?]", mypage_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
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
