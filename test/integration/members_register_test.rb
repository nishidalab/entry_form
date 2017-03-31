require 'test_helper'

class MembersRegisterTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid member_register information" do
    get member_register_path
    assert_no_difference 'Member.count' do
      post member_register_path, params: { member: {
          name: "", yomi: "", email: "hoge@fuga", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'members/new'
    # TODO google assert_template
    assert_select 'div#error_explanation'
  end

  test "valid member_register information" do
    get member_register_path
    assert_difference 'Member.count' do
      post member_register_path, params: { member: {
          name: "西田豊明", yomi: "にしだとよあき", email: "hoge@i.kyoto-u.ac.jp",
          password: "password", password_confirmation: "password" } }
    end
  end

  test "valid register information with account activation" do
    get member_register_path
    assert_difference 'Member.count', 1 do
      post member_register_path, params: { member: {
          name: "西田豊明", yomi: "にしだとよあき", email: "hoge@i.kyoto-u.ac.jp",
          password: "password", password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    member = assigns(:member)
    assert_not member.activated?
    # 有効化していない状態でログインする
    log_in_as_member member
    assert_not is_logged_in_member?
    # 有効化トークンが不正な場合
    get member_activate_url(t: "invalid_token", e: member.email)
    assert_not is_logged_in_member?
    # トークンは正しいがメールアドレスが無効な場合
    get member_activate_url(t: member.activation_token, e: "invalid")
    assert_not is_logged_in_member?
    # トークンの有効期限が切れている場合
    member.update(set_activation_token_at: member.set_activation_token_at - 86401)
    get member_activate_url(t: member.activation_token, e: member.email)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to member_login_url
    member.update(set_activation_token_at: member.set_activation_token_at + 86401)
    # 両方正しい場合
    get member_activate_url(t: member.activation_token, e: member.email)
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert member.reload.activated?
    assert_redirected_to member_mypage_path
  end
end
