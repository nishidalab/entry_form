require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
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
    @schedule = Schedule.new(experiment_id: @experiment.id, datetime: DateTime.now)
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
    (0..2).each do |i|
      @application.status = i
      assert @application.valid?, "status #{i} should be valid."
    end
  end

  test "status is invalid" do
    @application.status = -1
    assert_not @application.valid?
    @application.status = 3
    assert_not @application.valid?
  end

  test "should be unique" do
    dup = @application.dup
    @application.save
    dup.status = 1
    assert_not dup.valid?
  end
end
