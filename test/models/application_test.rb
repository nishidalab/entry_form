require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  def setup
    @now = Time.zone.now
    @participant = Participant.new(
        email: "test@example.com", name: "テスト", yomi: "てすと",  gender: 1, birth: Date.new(1992, 7, 31),
        classification: 1, grade: 1, faculty_id: 1, address: "京都市左京区吉田本町",
        password: "password", password_confirmation: "password")
    @participant.save
    @member = Member.new(
        email: "test@ii.ist.i.kyoto-u.ac.jp", name: "テスト", yomi: "てすと",
        password: "password", password_confirmation: "password")
    @member.save
    @experiment = Experiment.new(
        member_id: @member.id, zisshi_ukagai_date: Date.today, project_owner: "ほげ", place: "ほげ", budget: "ほげ",
        department_code: "123", project_num: "123", project_name: "ほげ", creditor_code: "XXX",
        expected_participant_count: 1, duration: 60, name: "ほげ", requirement: "ほげ", description: "ほげ",
        schedule_from: Date.today, schedule_to: Date.today, final_report_date: Date.today)
    @experiment.save
    @schedule = Schedule.new(experiment_id: @experiment.id, datetime: @now)
    @schedule.save
    @application = Application.new(participant_id: @participant.id, schedule_id: @schedule.id, status: 0)
  end

  test "should be valid" do
    assert @application.valid?
  end

  test "participant_id is invalid" do
    @application.participant_id = Participant.maximum(:id) + 1
    assert_not @application.valid?
  end

  test "schedule_id is invalid" do
    @application.schedule_id = Schedule.maximum(:id) + 1
    assert_not @application.valid?
  end

  test "status is valid" do
    (0..3).each do |i|
      @application.status = i
      assert @application.valid?, "status #{i} should be valid."
    end
  end

  test "status is invalid" do
    @application.status = -1
    assert_not @application.valid?
    @application.status = 4
    assert_not @application.valid?
  end

  test "should be unique" do
    dup = @application.dup
    @application.save
    dup.status = 2
    assert_not dup.valid?
  end

  test "schedule.participant_id should be filled when status become 1" do
    @application.status = 1
    assert @application.valid?
    @application.save
    assert_equal @application.participant_id, @application.schedule.participant_id
  end

  test "status should not become 1 if double booking" do
    # @application の10分後に開始するスケジュール(bad)と、60分後に開始するスケジュール(good)を登録
    another_experiment = Experiment.new(
        member_id: @member.id, zisshi_ukagai_date: Date.today, project_owner: "ほげ", place: "ほげ", budget: "ほげ",
        department_code: "123", project_num: "123", project_name: "ほげ", creditor_code: "XXX",
        expected_participant_count: 1, duration: 60, name: "ふが", requirement: "ほげ", description: "ほげ",
        schedule_from: Date.today, schedule_to: Date.today, final_report_date: Date.today)
    another_experiment.save
    bad_schedule = Schedule.new(experiment_id: another_experiment.id, datetime: @now + 10 * 60)
    bad_schedule.save
    good_schedule = Schedule.new(experiment_id: another_experiment.id, datetime: @now + 60 * 60)
    good_schedule.save

    # 時間内に既に確定している application が存在する
    bad_application = Application.new(participant_id: @participant.id, schedule_id: bad_schedule.id, status: 1)
    bad_application.valid?
    assert bad_application.valid?
    bad_application.save
    @application.status = 1
    assert_not @application.valid?
    bad_application.destroy

    # 終了時刻と開始時刻が被っているものは OK
    good_application = Application.new(participant_id: @participant.id, schedule_id: good_schedule.id, status: 1)
    assert good_application.valid?
    good_application.save
    @application.status = 1
    assert @application.valid?

    # 時間内に既に確定している event が存在する
    bad_event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: @now + 10 * 60,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
    bad_event.save
    @application.status = 1
    assert_not @application.valid?
    bad_event.destroy

    # 終了時刻と開始時刻が被っているものは OK
    good_event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: @now + 60 * 60,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
    good_event.save
    @application.status = 1
    assert @application.valid?
  end
end
