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

  test "newroom should redirect to member login page when not logged in" do
    get experiment_newroom_path
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

  test "show should have participants infomation" do
    @member1.admin = true
    @member1.save
    log_in_as_member(@member1)
    get experiment_path(@experiment1)
    # TODO status 置換
    participants = Participant.where(id: Application.where(schedule_id: Schedule.where(experiment_id: @experiment1.id).ids).where(status: [0, 1]).select(:participant_id))
    p_ids = []
    participants.each do |p|
      assert_select "table tr td", {:text => p.name}
      assert_select "table tr td", {:text => p.yomi}
      assert_select "table tr td", {:text => p.email, count: 0}
      assert_select "table tr td", {:text => p.address, count: 0}
      # TODO 実際はこのへんでacceptコントローラへのリンクとかも検証
      p_ids.push(p.id)
    end
    excluded_participants = Participant.all - Participant.where(id: p_ids)
    excluded_participants.each do |p|
      assert_select "table tr td", {:text => p.name, count: 0}
      assert_select "table tr td", {:text => p.yomi, count: 0}
      assert_select "table tr td", {:text => p.email, count: 0}
      assert_select "table tr td", {:text => p.address, count: 0}
    end
  end

  private
    # indexを実装していないのでマイページへのassertionを利用している
    # indexを実装したら対応する部分はすべてそれに書き換えよう
    def assertion_mypage
      follow_redirect!
      assert_template 'members/show'
    end
end
