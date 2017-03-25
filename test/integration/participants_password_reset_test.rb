require 'test_helper'

class ParticipantsPasswordResetTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @participant = participants(:one)
  end

  def submit_reset(email)
    post reset_path, params: { password_reset: { email: email } }
  end

  def submit_update(token, email, password, password_confirmation)
    patch update_reset_path(token), params: { e: email, participant:
        { password: password, password_confirmation: password_confirmation } }
  end

  test "password reset" do
    get reset_path
    assert_template 'participant_password_resets/new'
    # メールアドレスが無効
    submit_reset 'invalid'
    assert_not flash.empty?
    assert_template 'participant_password_resets/new'
    # メールアドレスが有効
    submit_reset @participant.email
    assert_not_equal @participant.reset_digest, @participant.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?

    # パスワード再設定フォーム
    participant = assigns(:user)
    follow_redirect!
    assert_redirected_to login_url
    # メールアドレスが無効
    get edit_reset_path(participant.reset_token, e: '')
    assert_redirected_to login_url
    # アクティベートされていない被験者
    participant.toggle!(:activated)
    get edit_reset_path(participant.reset_token, e: participant.email.upcase)
    assert_redirected_to login_url
    participant.toggle!(:activated)
    # トークンが無効
    get edit_reset_path('invalid', e: participant.email.upcase)
    assert_redirected_to login_url
    # トークンの有効期限切れ
    participant.update(reset_sent_at: participant.reset_sent_at - 3601)
    get edit_reset_path(participant.reset_token, e: participant.email.upcase)
    assert_not flash.empty?
    assert_redirected_to reset_url
    participant.update(reset_sent_at: participant.reset_sent_at + 3601)
    # 有効
    get edit_reset_path(participant.reset_token, e: participant.email.upcase)
    assert_template 'participant_password_resets/edit'
    assert_select "input[name=e][type=hidden][value=?]", participant.email

    # パスワードと確認が一致しない
    submit_update(participant.reset_token, participant.email.upcase, 'hogehoge', 'fugafuga')
    assert_select 'div#error_explanation'
    # パスワードが空
    submit_update(participant.reset_token, participant.email.upcase, '', '')
    assert_select 'div#error_explanation'
    # パスワードが足りてない
    submit_update(participant.reset_token, participant.email.upcase, 'aaa', 'aaa')
    assert_select 'div#error_explanation'
    # トークンの有効期限切れ
    participant.update(reset_sent_at: participant.reset_sent_at - 3601)
    submit_update(participant.reset_token, participant.email.upcase, 'password', 'password')
    assert_not flash.empty?
    assert_redirected_to reset_url
    participant.update(reset_sent_at: participant.reset_sent_at + 3601)
    # 有効なパスワード
    submit_update(participant.reset_token, participant.email.upcase, 'password', 'password')
    assert is_logged_in_participant?
    assert_not flash.empty?
    assert_redirected_to mypage_url
    assert_nil participant.reload.reset_digest
    assert_nil participant.reload.reset_sent_at
  end
end
