require 'test_helper'

class ParticipantsMypageTest < ActionDispatch::IntegrationTest
  def setup
    @test = participants(:one)
  end

  def apply(schedule, status)
    Application.create!(participant_id: @test.id, schedule_id: schedule.id, status: status)
  end

  test "mypage shows schedules of logged in participant" do
    log_in_as_participant @test
    get mypage_path

    # 予定がない時はカレンダーに何も表示されない
    assert_select 'div.test', count: 0

    # 実験参加申請をする(申請中・確定・拒否を1件ずつ)
    apply(schedules(:two), ApplicationStatus::APPLYING)
    apply(schedules(:three), ApplicationStatus::ACCEPTED)
    apply(schedules(:four), ApplicationStatus::CANCELED)
    apply(schedules(:six), ApplicationStatus::REJECTED)
    get mypage_path
    assert_template 'participants/show'

    # 申請中の予定がカレンダーに表示される
    assert_select 'div[class=?]', "#{schedules(:two).experiment.name}0"

    # 確定した予定がカレンダーに表示される
    assert_select 'div[class=?]', "#{schedules(:three).experiment.name}1"

    # 拒否した予定がカレンダーに表示されない
    assert_select 'div[class=?]', "#{schedules(:four).experiment.name}2", count: 0

    # 強い拒否をした予定がカレンダーに表示されない
    assert_select 'div[class=?]', "#{schedules(:five).experiment.name}3", count: 0

    # 実験外予定がカレンダーに表示される
    assert_select 'div[class=?]', "#{events(:one).name}#{events(:one).experiment.name}"
  end
end
