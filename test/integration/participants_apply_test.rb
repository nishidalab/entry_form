require 'test_helper'

class ParticipantsApplyTest < ActionDispatch::IntegrationTest
  def setup
    @max_experiment_id = Experiment.maximum(:id)
    @max_schedule_id = Schedule.maximum(:id)
  end

  def apply(experiment: 1, schedules: [1, 2])
    post applications_path, params: { experiment: experiment, schedules: schedules }
  end

  test "!!FAILURE!! should reject when not logged in" do
    # 必ず落ちるテスト。ログインページが実装されたらこのテストも実装する。
    post applications_path, params: { experiment: 1, schedules: [1] }
    assert false
  end

  test "valid experiment and schedules" do
    assert_difference 'Application.count', 2 do
      apply
    end
    assert_redirected_to applications_url
  end

  test "invalid experiment" do
    assert_no_difference 'Application.count' do
      apply experiment: @max_experiment_id + 1
    end
    assert_redirected_to new_application_url
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
      apply experiment: @max_experiment_id, schedules: [@max_schedule_id]
    end
    assert_redirected_to applications_url
    assert_no_difference 'Application.count' do
      apply experiment: @max_experiment_id, schedules: [@max_schedule_id]
    end
    assert_redirected_to new_application_url
  end
end
