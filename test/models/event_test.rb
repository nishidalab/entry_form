require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @participant = Participant.new(
        email: "test@example.com", name: "テスト", yomi: "てすと",  gender: 1, birth: Date.new(1992, 7, 31),
        classification: 1, grade: 1, faculty: 1, address: "京都市左京区吉田本町",
        password: "password", password_confirmation: "password")
    @participant.save
    @member = Member.new(
        email: "test@example.com", name: "テスト", yomi: "てすと",
        password: "password", password_confirmation: "password")
    @member.save
    @experiment = Experiment.new(
        member_id: @member.id, zisshi_ukagai_date: Date.today, project_owner: "ほげ", place: "ほげ", budget: "ほげ",
        department_code: "123", project_num: "123", project_name: "ほげ", creditor_code: "XXX",
        expected_participant_count: 1, duration: 1, name: "ほげ", requirement: "ほげ", description: "ほげ",
        schedule_from: Date.today, schedule_to: Date.today, final_report_date: Date.today)
    @experiment.save
    @event = Event.new(
        name: "事前手続き", requirement: "必要なこと", description: "説明", place: "場所", start_at: DateTime.now,
        duration: 10, experiment_id: @experiment.id, participant_id: @participant.id)
  end

  test "should be valid" do
    assert @event.valid?
  end

  test "name should be present" do
    @event.name = "    "
    assert_not @event.valid?
  end

  test "name should not be too long" do
    @event.name = "a" * 101
    assert_not @event.valid?
  end

  test "requirement does not have to be present" do
    @event.requirement = ""
    assert @event.valid?
  end

  test "requirement should not be too long" do
    @event.requirement = "a" * 401
    assert_not @event.valid?
  end

  test "description should not be too long" do
    @event.description = "a" * 401
    assert_not @event.valid?
  end

  test "place should be present" do
    @event.place = "    "
    assert_not @event.valid?
  end

  test "start_at should be present" do
    @event.start_at = nil
    assert_not @event.valid?
  end

  test "duration should be present" do
    @event.duration = nil
    assert_not @event.valid?
  end

  test "duration should be greater than 0" do
    @event.duration = 0
    assert_not @event.valid?
  end

  test "experiment_id is invalid" do
    @event.experiment_id = Experiment.maximum(:id) + 1
    assert_not @event.valid?
  end

  test "participant_id is invalid" do
    @event.participant_id = Participant.maximum(:id) + 1
    assert_not @event.valid?
  end
end
