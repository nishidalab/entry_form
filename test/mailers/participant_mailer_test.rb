require 'test_helper'

class ParticipantMailerTest < ActionMailer::TestCase
  test "account_activation" do
    participant = participants(:one)
    participant.activation_token = Participant.new_token
    mail = ParticipantMailer.account_activation(participant)
    assert_equal "アカウント本登録URLについて", mail.subject
    assert_equal [participant.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    assert_match participant.name, mail.text_part.body.encoded
    assert_match participant.activation_token, mail.text_part.body.encoded
    assert_match CGI.escape(participant.email), mail.text_part.body.encoded
    assert_match participant.name, mail.html_part.body.encoded
    assert_match participant.activation_token, mail.html_part.body.encoded
    assert_match CGI.escape(participant.email), mail.html_part.body.encoded
  end

  test "account_activated" do
    participant = participants(:one)
    mail = ParticipantMailer.account_activated(participant)
    assert_equal "アカウント登録が完了しました", mail.subject
    assert_equal [participant.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    assert_match participant.name, mail.text_part.body.encoded
    applications_url = 'https://ii.ist.i.kyoto-u.ac.jp/experiment/applications'
    mypage_url = 'https://ii.ist.i.kyoto-u.ac.jp/experiment/mypage'
    assert_match applications_url, mail.text_part.body.encoded
    assert_match mypage_url, mail.text_part.body.encoded
    assert_match participant.name, mail.html_part.body.encoded
    assert_match applications_url, mail.html_part.body.encoded
    assert_match mypage_url, mail.html_part.body.encoded
  end
end
