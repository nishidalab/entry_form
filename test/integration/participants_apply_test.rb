require 'test_helper'

class ParticipantsApplyTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @schedules = [schedules(:one).id, schedules(:two).id]
    @experiment_id = schedules(:one).experiment_id
    @max_schedule_id = Schedule.maximum(:id)
  end

  def apply(schedules = nil)
    schedules = @schedules if schedules.nil?
    post applications_path, params: { experiment: @experiment_id, schedules: schedules }
  end

  test "should reject when not logged in" do
    apply
    assert_redirected_to login_url
  end

  test "valid schedules" do
    log_in_as_participant(@participant)
    assert_difference 'Application.count', 2 do
      apply
    end
    assert_redirected_to applications_url
    follow_redirect!
    assert_select 'div.alert-success'
  end

  test "schedule is empty" do
    log_in_as_participant(@participant)
    assert_no_difference 'Application.count' do
      apply []
    end
    follow_redirect!
    assert_select 'div.alert-danger'
  end

  test "contains invalid schedule" do
    log_in_as_participant(@participant)
    assert_difference 'Application.count', 1 do
      apply [@max_schedule_id, @max_schedule_id + 1]
    end
    assert_redirected_to applications_url
    follow_redirect!
    assert_select 'div.alert-success'
  end

  test "multi apply" do
    log_in_as_participant(@participant)
    assert_difference 'Application.count', 1 do
      apply [@max_schedule_id]
    end
    assert_redirected_to applications_url
    follow_redirect!
    assert_select 'div.alert-success'
    assert_no_difference 'Application.count' do
      apply [@max_schedule_id]
    end
    follow_redirect!
    assert_select 'div.alert-danger'
  end
end
