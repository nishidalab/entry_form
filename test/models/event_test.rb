require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @participant = Participant.new(
        email: "test@example.com", name: "テスト", yomi: "てすと",  gender: 1, birth: Date.new(1992, 7, 31),
        classification: 1, grade: 1, faculty_id: 1, address: "京都市左京区吉田本町",
        password: "password", password_confirmation: "password")
    @participant.save
    @member = Member.new(
        email: "test@example.com", name: "テスト", yomi: "てすと",
        password: "password", password_confirmation: "password")
    @member.save
    @experiment = Experiment.new(
        member_id: @member.id, zisshi_ukagai_date: Date.today, project_owner: "ほげ", place: "ほげ", budget: "ほげ",
        department_code: "123", project_num: "123", project_name: "ほげ", creditor_code: "XXX",
        expected_participant_count: 1, duration: 60, name: "ほげ", requirement: "ほげ", description: "ほげ",
        schedule_from: Date.today, schedule_to: Date.today, final_report_date: Date.today)
    @experiment.save
    @now = Time.zone.now
  end

  def setup_event
    @event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: @now,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
  end

  test "should be valid" do
    setup_event
    assert @event.valid?
  end

  test "name should be present" do
    setup_event
    @event.name = "    "
    assert_not @event.valid?
  end

  test "name should not be too long" do
    setup_event
    @event.name = "a" * 101
    assert_not @event.valid?
  end

  test "requirement does not have to be present" do
    setup_event
    @event.requirement = ""
    assert @event.valid?
  end

  test "requirement should not be too long" do
    setup_event
    @event.requirement = "a" * 401
    assert_not @event.valid?
  end

  test "description should not be too long" do
    setup_event
    @event.description = "a" * 401
    assert_not @event.valid?
  end

  test "place should be present" do
    setup_event
    @event.place = "    "
    assert_not @event.valid?
  end

  test "start_at should be present" do
    setup_event
    @event.start_at = nil
    assert_not @event.valid?
  end

  test "duration should be present" do
    setup_event
    @event.duration = nil
    assert_not @event.valid?
  end

  test "duration should be greater than 0" do
    setup_event
    @event.duration = 0
    assert_not @event.valid?
  end

  test "experiment_id is invalid" do
    setup_event
    @event.experiment_id = Experiment.maximum(:id) + 1
    assert_not @event.valid?
  end

  test "participant_id is invalid" do
    setup_event
    @event.participant_id = Participant.maximum(:id) + 1
    assert_not @event.valid?
  end

  test "check double booking (conflicting application)" do
    schedule = Schedule.new(experiment_id: @experiment.id, datetime: @now + 5 * 60)
    schedule.save
    application = Application.new(participant_id: @participant.id, schedule_id: schedule.id, status: 1)
    application.save
    setup_event
    assert_not @event.valid?
  end

  test "check double booking (not conflicting application)" do
    schedule = Schedule.new(experiment_id: @experiment.id, datetime: @now + 10 * 60)
    schedule.save
    application = Application.new(participant_id: @participant.id, schedule_id: schedule.id, status: 1)
    application.save
    setup_event
    assert @event.valid?
  end

  test "check double booking (conflicting event)" do
    another_event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: @now + 5 * 60,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
    assert another_event.valid?
    another_event.save
    setup_event
    assert_not @event.valid?
  end

  test "check double booking (not conflicting event)" do
    another_event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: @now + 10 * 60,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
    assert another_event.valid?
    another_event.save
    setup_event
    assert @event.valid?
  end
end
