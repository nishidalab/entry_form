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

  test "experiment_applied" do
    application = applications(:one)
    participant = application.participant
    schedule = application.schedule
    experiment = schedule.experiment
    start_at = schedule.datetime
    end_at = schedule.datetime + experiment.duration * 3600
    mail = ParticipantMailer.experiment_applied(participant, [schedule])
    assert_equal "#{experiment.name}への応募が完了しました", mail.subject
    assert_equal [participant.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    [mail.text_part.body.encoded, mail.html_part.body.encoded].each do |body|
      assert_match participant.name, body
      assert_match experiment.name, body
      assert_match start_at.to_s, body
      assert_match end_at.to_s, body
      mypage_url = 'https://ii.ist.i.kyoto-u.ac.jp/experiment/mypage'
      assert_match mypage_url, body
    end
  end
end
