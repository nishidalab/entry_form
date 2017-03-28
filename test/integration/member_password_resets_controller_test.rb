require 'test_helper'

class MemberPasswordResetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @member = members(:one)
  end

  def submit_reset(email)
    post member_reset_path, params: { password_reset: { email: email } }
  end

  def submit_update(token, email, password, password_confirmation)
    patch member_update_reset_path(token), params: { e: email, member:
        { password: password, password_confirmation: password_confirmation } }
  end

  test "password reset" do
    get member_reset_path
    assert_template 'member_password_resets/new'
    # メールアドレスが無効
    submit_reset 'invalid'
    assert_not flash.empty?
    assert_template 'member_password_resets/new'
    # メールアドレスが有効
    submit_reset @member.email
    assert_not_equal @member.reset_digest, @member.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?

    # パスワード再設定フォーム
    member = assigns(:user)
    assert_redirected_to member_login_url
    # メールアドレスが無効
    get member_edit_reset_path(member.reset_token, e: '')
    assert_redirected_to member_login_url
    # アクティベートされていない被験者
    member.toggle!(:activated)
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_redirected_to member_login_url
    member.toggle!(:activated)
    # トークンが無効
    get member_edit_reset_path('invalid', e: member.email.upcase)
    assert_redirected_to member_login_url
    # トークンの有効期限切れ
    member.update(reset_sent_at: member.reset_sent_at - 3601)
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_not flash.empty?
    assert_redirected_to member_reset_url
    member.update(reset_sent_at: member.reset_sent_at + 3601)
    # 有効
    get member_edit_reset_path(member.reset_token, e: member.email.upcase)
    assert_template 'member_password_resets/edit'
    assert_select "input[name=e][type=hidden][value=?]", member.email

    # パスワードと確認が一致しない
    submit_update(member.reset_token, member.email.upcase, 'hogehoge', 'fugafuga')
    assert_select 'div#error_explanation'
    # パスワードが空
    submit_update(member.reset_token, member.email.upcase, '', '')
    assert_select 'div#error_explanation'
    # パスワードが足りてない
    submit_update(member.reset_token, member.email.upcase, 'aaa', 'aaa')
    assert_select 'div#error_explanation'
    # トークンの有効期限切れ
    member.update(reset_sent_at: member.reset_sent_at - 3601)
    submit_update(member.reset_token, member.email.upcase, 'password', 'password')
    assert_not flash.empty?
    assert_redirected_to member_reset_url
    member.update(reset_sent_at: member.reset_sent_at + 3601)
    # 有効なパスワード
    submit_update(member.reset_token, member.email.upcase, 'password', 'password')
    assert is_logged_in_member?
    assert_not flash.empty?
    assert_redirected_to member_mypage_url
    assert_nil member.reload.reset_digest
    assert_nil member.reload.reset_sent_at
  end
end
