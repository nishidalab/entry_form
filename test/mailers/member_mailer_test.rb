require 'test_helper'

class MemberMailerTest < ActionMailer::TestCase
  test "experiment_applied" do
    application = applications(:one)
    participant = application.participant
    schedule = application.schedule
    experiment = schedule.experiment
    member = experiment.member
    start_at = schedule.datetime
    end_at = schedule.datetime + experiment.duration * 60
    mail = MemberMailer.experiment_applied(participant, [schedule])
    assert_equal "#{experiment.name}応募(#{participant.name})", mail.subject
    assert_equal [member.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    [mail.text_part.body.encoded, mail.html_part.body.encoded].each do |body|
      assert_match member.name, body
      assert_match experiment.name, body
      assert_match start_at.to_s, body
      assert_match end_at.to_s, body
      assert_match participant.name, body
      assert_match participant.yomi, body
      assert_match Participant.gender_to_s(participant.gender), body
      assert_match participant.birth.to_s, body
    end
  end

  test "account_activation" do
    member = members(:one)
    member.activation_token = Member.new_token
    mail = MemberMailer.account_activation(member)
    assert_equal "アカウント本登録URLについて", mail.subject
    assert_equal [member.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    assert_match member.name, mail.text_part.body.encoded
    assert_match member.activation_token, mail.text_part.body.encoded
    assert_match CGI.escape(member.email), mail.text_part.body.encoded
    assert_match member.name, mail.html_part.body.encoded
    assert_match member.activation_token, mail.html_part.body.encoded
    assert_match CGI.escape(member.email), mail.html_part.body.encoded
  end

  test "account_activated" do
    member = members(:one)
    mail = MemberMailer.account_activated(member)
    assert_equal "アカウント登録が完了しました", mail.subject
    assert_equal [member.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    assert_match member.name, mail.text_part.body.encoded
    recruit_url = 'https://ii.ist.i.kyoto-u.ac.jp/experiment/experiments/new'
    mypage_url = 'https://ii.ist.i.kyoto-u.ac.jp/experiment/member/mypage'
    assert_match recruit_url, mail.text_part.body.encoded
    assert_match mypage_url, mail.text_part.body.encoded
    assert_match member.name, mail.html_part.body.encoded
    assert_match recruit_url, mail.html_part.body.encoded
    assert_match mypage_url, mail.html_part.body.encoded
  end

  test "password_reset" do
    member = members(:one)
    member.reset_token = Member.new_token
    mail = MemberMailer.password_reset(member)
    assert_equal "パスワードの再設定", mail.subject
    assert_equal [member.email], mail.to
    assert_equal ["no-reply@ii.ist.i.kyoto-u.ac.jp"], mail.from
    [mail.text_part.body.encoded, mail.html_part.body.encoded].each do |body|
      assert_match member.name, body
      assert_match member.reset_token, body
      assert_match CGI.escape(member.email), body
    end
  end
end
