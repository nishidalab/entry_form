require 'test_helper'

class ParticipantsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @deactivated_participant = participants(:three)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get login_path
    assert flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", applications_path, count: 0
    assert_select "a[href=?]", inquiries_new_path, count: 0
    assert_select "a[href=?]", inquiries_path, count: 0
    assert_select "a[href=?]", mypage_path, count: 0
    assert_select "a[href=?]", settings_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path
      assert_select "[href=?]", mypage_path, count: 0
    end
  end

  test "login with valid information and logout" do
    get login_path
    log_in_as_participant @participant
    follow_redirect!
    assert_template 'applications/index'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", applications_path
    assert_select "a[href=?]", inquiries_new_path
    assert_select "a[href=?]", inquiries_path
    assert_select "a[href=?]", mypage_path
    assert_select "a[href=?]", settings_path
    assert_select "a[href=?]", logout_path
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path, count: 0
      assert_select "[href=?]", mypage_path
    end
    delete logout_path
    assert_redirected_to participant_login_url
    follow_redirect!
    assert_redirected_to login_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", applications_path, count: 0
    assert_select "a[href=?]", inquiries_new_path, count: 0
    assert_select "a[href=?]", inquiries_path, count: 0
    assert_select "a[href=?]", mypage_path, count: 0
    assert_select "a[href=?]", settings_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path
      assert_select "[href=?]", mypage_path, count: 0
    end
  end

  test "login with remembering" do
    log_in_as_participant @participant, remember_me: '1'
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as_participant @participant, remember_me: '0'
    assert_nil cookies['remember_token']
  end

  test "login as deactivated participant" do
    get login_path
    log_in_as_participant @deactivated_participant
    assert_template 'sessions/new'
    assert_not flash.empty?
    get login_path
    assert flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", applications_path, count: 0
    assert_select "a[href=?]", inquiries_new_path, count: 0
    assert_select "a[href=?]", inquiries_path, count: 0
    assert_select "a[href=?]", mypage_path, count: 0
    assert_select "a[href=?]", settings_path, count: 0
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path
      assert_select "[href=?]", mypage_path, count: 0
    end
  end
end
