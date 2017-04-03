require 'test_helper'

class MembersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:one)
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

  test "member login with valid information and logout" do
    get member_login_path
    log_in_as_member @member
    assert is_logged_in_member?
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

  test "login with remembering" do
    log_in_as_member @member, remember_me: '1'
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as_member @member, remember_me: '0'
    assert_nil cookies['remember_token']
  end
end
