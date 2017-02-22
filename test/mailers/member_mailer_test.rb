require 'test_helper'

class MemberMailerTest < ActionMailer::TestCase
  test "experiment_applied" do
    application = applications(:one)
    participant = application.participant
    schedule = application.schedule
    experiment = schedule.experiment
    member = experiment.member
    start_at = schedule.datetime
    end_at = schedule.datetime + experiment.duration * 3600
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
end
