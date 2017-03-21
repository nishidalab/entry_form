require 'test_helper'

class ExperimentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member1 = members(:one)
    @member2 = members(:two)
    @experiment1 = experiments(:one)
    @experiment2 = experiments(:two)
    @max_experiment_id = Experiment.maximum(:id)
  end

  test "should get index" do
    log_in_as_member(@member1)
    get experiments_path
    follow_redirect!
    assert_template 'members/show'
  end

  test "index should redirect to member login page when not logged in" do
    get experiments_path
    assert_redirected_to member_login_url
  end

  test "new should redirect to member login page when not logged in" do
    get new_experiment_path
    assert_redirected_to member_login_url
  end

  test "show should redirect to index when parameter experiment is invalid" do
    log_in_as_member(@member1)
    get experiment_path(@max_experiment_id + 1)
    assertion_mypage
  end

  test "show should redirect to index when parameter experiment is not owned" do
    log_in_as_member(@member1)
    get experiment_path(@experiment2)
    assertion_mypage
    log_out_as_member
    log_in_as_member(@member2)
    get experiment_path(@experiment1)
    assertion_mypage
  end

  test "should get show when parameter experiment is valid and owned" do
    log_in_as_member(@member1)
    get experiment_path(@experiment1)
    assert_template 'experiments/show'
    log_out_as_member
    log_in_as_member(@member2)
    get experiment_path(@experiment2)
    assert_template 'experiments/show'
  end

  private
    # indexを実装していないのでマイページへのassertionを利用している
    # indexを実装したら対応する部分はすべてそれに書き換えよう
    def assertion_mypage
      assert_redirected_to member_mypage_path
      follow_redirect!
      assert_template 'members/show'
    end
end
