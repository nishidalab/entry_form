require 'test_helper'

class ApplicationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @max_experiment_id = Experiment.maximum(:id)
  end

  test "should get index" do
    log_in_as_participant(@participant)
    get applications_path
    assert_response :success
  end

  test "index should redirect to login page when not logged in" do
    get applications_path
    assert_redirected_to login_url
  end

  test "new should redirect to login page when not logged in" do
    get new_application_path
    assert_redirected_to login_url
  end

  test "new should redirect to index when parameter experiment is nil" do
    log_in_as_participant(@participant)
    get new_application_path
    assert_redirected_to applications_path
    follow_redirect!
    assert_template 'applications/index'
  end

  test "new should redirect to index when parameter experiment is invalid" do
    log_in_as_participant(@participant)
    get new_application_path, params: { experiment: @max_experiment_id + 1 }
    assert_redirected_to applications_path
    follow_redirect!
    assert_template 'applications/index'
  end

  test "should get new when parameter experiment is valid" do
    log_in_as_participant(@participant)
    get new_application_path, params: { experiment: @max_experiment_id }
    assert_template 'applications/new'
  end
end
