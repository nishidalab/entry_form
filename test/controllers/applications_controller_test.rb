require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @max_experiment_id = Experiment.maximum(:id)
  end

  test "should get index" do
    get applications_path
    assert_response :success
  end

  test "!!FAILURE!! index should redirect to login page when not logged in" do
    # 必ず落ちるテスト。ログインページが実装されたらこのテストも実装する。
    get applications_path
    assert false
  end

  test "!!FAILURE!! new should redirect to login page when not logged in" do
    # 必ず落ちるテスト。ログインページが実装されたらこのテストも実装する。
    get new_application_path
    assert false
  end

  test "new should redirect to index when parameter experiment is nil" do
    get new_application_path
    assert_redirected_to applications_path
    follow_redirect!
    assert_template 'applications/index'
  end

  test "new should redirect to index when parameter experiment is invalid" do
    puts @max_experiment_id
    get new_application_path, params: { experiment: @max_experiment_id + 1 }
    assert_redirected_to applications_path
    follow_redirect!
    assert_template 'applications/index'
  end

  test "should get new when parameter experiment is valid" do
    get new_application_path, params: { experiment: @max_experiment_id }
    assert_template 'applications/new'
  end
end
