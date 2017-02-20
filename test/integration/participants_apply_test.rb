require 'test_helper'

class ParticipantsApplyTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @max_schedule_id = Schedule.maximum(:id)
  end

  def apply(schedules: [1, 2])
    log_in_as_participant(@participant)
    post applications_path, params: { schedules: schedules }
  end

  test "should reject when not logged in" do
    post applications_path, params: { schedules: [1] }
    assert_redirected_to login_url
  end

  test "valid schedules" do
    assert_difference 'Application.count', 2 do
      apply
    end
    assert_redirected_to applications_url
  end

  test "schedule is empty" do
    assert_no_difference 'Application.count' do
      apply schedules: []
    end
    assert_redirected_to new_application_url
  end

  test "contains invalid schedule" do
    assert_no_difference 'Application.count' do
      apply schedules: [@max_schedule_id, @max_schedule_id + 1]
    end
    assert_redirected_to new_application_url
  end

  test "multi apply" do
    assert_difference 'Application.count', 1 do
      apply schedules: [@max_schedule_id]
    end
    assert_redirected_to applications_url
    assert_no_difference 'Application.count' do
      apply schedules: [@max_schedule_id]
    end
    assert_redirected_to new_application_url
  end
end
