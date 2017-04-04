require 'test_helper'

class MemberControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test = members(:one)
    @admin = members(:admin)
  end

  test "member register should get member register when not logged in" do
    get member_register_path
    assert_response :success
  end

  test "member register should get member mypage when logged in" do
    log_in_as_member @test
    get member_register_path
    assert_redirected_to member_mypage_url

    log_out_as_member
    log_in_as_member @admin
    get member_register_path
    assert_redirected_to member_mypage_url
  end

  test "member mypage should redirect to member login when not logged in" do
    get member_mypage_path
    assert_redirected_to member_login_url
  end

  test "member mypage should get member mypage when logged in" do
    log_in_as_member @test
    get member_mypage_path
    assert_template 'members/show'

    log_out_as_member
    log_in_as_member @admin
    get member_mypage_path
    assert_template 'members/show'
  end

  test "only admin member mypage should have links to his experiments" do
    log_in_as_member @test
    get member_mypage_path
    Experiment.where(member_id: @test.id).each do |experiment|
      assert_select "a[href=?]", experiment_path(experiment), count: 0
    end

    log_out_as_member
    log_in_as_member @admin
    get member_mypage_path
    Experiment.where(member_id: @admin.id).each do |experiment|
      assert_select "a[href=?]", experiment_path(experiment)
    end
  end

  test "member mypage should have his experiments schedules" do
    log_in_as_member @test
    get member_mypage_path
    instance_schedules = assigns(:schedules)
    experiments = Experiment.where(member_id: @test.id)
    schedules = Schedule.where(experiment_id: experiments.ids)
    assert (schedules - instance_schedules).empty?
    assert (instance_schedules - schedules).empty?
  end
end
