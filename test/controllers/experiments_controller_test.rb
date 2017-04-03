require 'test_helper'

class ExperimentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @member1 = members(:one)
    @member2 = members(:two)
    @admin = members(:admin)
    @experiment1 = experiments(:one)
    @experiment2 = experiments(:two)
    @max_experiment_id = Experiment.maximum(:id)
  end

  test "should get index" do
    log_in_as_member(@member1)
    get experiments_path
    assertion_normal_member_redirect_to_mypage

    log_out_as_member
    log_in_as_member(@admin)
    get experiments_path
    assertion_mypage
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
    assertion_normal_member_redirect_to_mypage

    log_out_as_member
    log_in_as_member(@admin)
    get experiment_path(@max_experiment_id + 1)
    assertion_mypage
  end

  test "show should redirect to index when parameter experiment is not owned" do
    @member1.admin = true
    @member2.admin = true
    @member1.save
    @member2.save
    log_in_as_member(@member1)
    get experiment_path(@experiment2)
    assertion_mypage
    log_out_as_member
    log_in_as_member(@member2)
    get experiment_path(@experiment1)
    assertion_mypage
  end

  test "should get show when parameter experiment is valid and owned" do
    @member1.admin = true
    @member2.admin = true
    @member1.save
    @member2.save
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
      follow_redirect!
      assert_template 'members/show'
    end
end
