require 'test_helper'

class ParticipantsRegisterTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid register information" do
    get register_path
    assert_no_difference 'Participant.count' do
      post register_path, params: { participant: {
          name: "", yomi: "", gender: 1, classification: 1, grade: 1, faculty_id: 1, address: "",
          birth: "2100-01-01", email: "hoge@fuga", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'participants/new'
    assert_select 'div#error_explanation'
  end

  test "valid register information with account activation" do
    get register_path
    assert_difference 'Participant.count', 1 do
      post register_path, params: { participant: {
          name: "西田豊明", yomi: "にしだとよあき", gender: 1, classification: 1, grade: 1, faculty_id: 1,
          address: "京都市左京区吉田本町", birth: "1995-01-01", email: "hoge@fuga.com",
          password: "password", password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    participant = assigns(:participant)
    assert_not participant.activated?
    # 有効化していない状態でログインする
    log_in_as_participant participant
    assert_not is_logged_in_participant?
    # 有効化トークンが不正な場合
    get activate_url(t: "invalid_token", e: participant.email)
    assert_not is_logged_in_participant?
    # トークンは正しいがメールアドレスが無効な場合
    get activate_url(t: participant.activation_token, e: "invalid")
    assert_not is_logged_in_participant?
    # トークンの有効期限が切れている場合
    participant.update(set_activation_token_at: participant.set_activation_token_at - 86401)
    get activate_url(t: participant.activation_token, e: participant.email)
    assert_equal 1, ActionMailer::Base.deliveries.size
    follow_redirect!
    assert_redirected_to login_url
    participant.update(set_activation_token_at: participant.set_activation_token_at + 86401)
    # 両方正しい場合
    get activate_url(t: participant.activation_token, e: participant.email)
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert participant.reload.activated?
    assert_redirected_to applications_url
    follow_redirect!
    assert is_logged_in_participant?
  end
end
