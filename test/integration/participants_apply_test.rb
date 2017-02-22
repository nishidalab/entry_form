require 'test_helper'

class ParticipantsApplyTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @schedules = [schedules(:two).id, schedules(:three).id]
    @experiment_id = schedules(:two).experiment_id
    @max_schedule_id = Schedule.maximum(:id)
    ActionMailer::Base.deliveries.clear
  end

  def apply(schedules = nil, experiment_id = nil)
    schedules = @schedules if schedules.nil?
    experiment_id = @experiment_id if experiment_id.nil?
    post applications_path, params: { experiment: experiment_id, schedules: schedules }
  end

  test "should reject when not logged in" do
    apply
    assert_redirected_to login_url
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

  test "valid apply and multi apply" do
    experiment_id = schedules(:two).experiment.id
    new_path = new_application_path + "?experiment=#{experiment_id}"
    log_in_as_participant(@participant)
    get applications_path
    assert_select "a[href=?]", new_path
    get new_path
    assert_response :success
    assert_difference 'Application.count', 2 do
      apply [schedules(:two).id, schedules(:three).id], experiment_id
    end
    assert_equal 2, ActionMailer::Base.deliveries.size
    assert_redirected_to applications_url
    follow_redirect!
    assert_select 'div.alert-success'
    assert_select "a[href=?]", new_path, count: 0
    get new_application_path, params: { experiment: experiment_id }
    assert_redirected_to applications_url
    follow_redirect!
    assert_no_difference 'Application.count' do
      apply [schedules(:two).id], experiment_id
    end
    assert_equal 2, ActionMailer::Base.deliveries.size
  end
end
