require 'test_helper'

class LayoutTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:one)
    @admin = members(:admin)
    @participant = participants(:one)
    @deactivated_participant = participants(:three)
  end

  test "member login with invalid information" do
    get member_login_path
    assert_template 'sessions/new'
    post member_login_path params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get member_login_path
    assert flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", member_mypage_path, count: 0
    assert_select "a[href=?]", member_logout_path, count: 0
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path
      assert_select "[href=?]", mypage_path, count: 0
      assert_select "[href=?]", member_mypage_path, count: 0
    end
  end

  test "normal member login with valid information and logout" do
    get member_login_path
    log_in_as_member @member
    assert is_logged_in_member?
    follow_redirect!
    assert_template 'members/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", member_mypage_path
    assert_select "a[href=?]", member_logout_path
    delete member_logout_path
    assert_redirected_to member_login_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", member_mypage_path, count: 0
    assert_select "a[href=?]", member_logout_path, count: 0
  end

  test "admin member login with valid information and logout" do
    get member_login_path
    log_in_as_member @admin
    assert is_logged_in_member?
    assert is_logged_in_admin_member?
    follow_redirect!
    assert_template 'members/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", member_mypage_path
    assert_select "a[href=?]", member_logout_path
    assert_select "a[href=?]", new_experiment_path
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path, count: 0
      assert_select "[href=?]", mypage_path, count: 0
      assert_select "[href=?]", member_mypage_path
    end
    delete member_logout_path
    assert_redirected_to member_login_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", member_mypage_path, count: 0
    assert_select "a[href=?]", member_logout_path, count: 0
    assert_select "a[href=?]", new_experiment_path, count: 0
    assert_select "a", {:text => 'Nishida Lab.'} do
      assert_select "[href=?]", root_path
      assert_select "[href=?]", mypage_path, count: 0
      assert_select "[href=?]", member_mypage_path, count: 0
    end
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
      assert_select "[href=?]", member_mypage_path, count: 0
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
      assert_select "[href=?]", member_mypage_path, count: 0
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
      assert_select "[href=?]", member_mypage_path, count: 0
    end
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
      assert_select "[href=?]", member_mypage_path, count: 0
    end
  end
end
