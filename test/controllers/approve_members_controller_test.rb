require 'test_helper'

class ApproveMembersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test = members(:one)
    @admin = members(:admin)
  end

  test "approve members should redirect to member login when not logged in" do
    get member_approve_path
    assert_redirected_to member_login_path
  end

  test "approve members should redirect to member mypage when logged in as normal member" do
    log_in_as_member @test
    get member_approve_path
    assert_redirected_to member_mypage_url
  end

  test "approve members should get approve members when logged in as admin member" do
    log_in_as_member @admin
    get member_approve_path
    assert_template 'approve_members/show'
  end

  test "patch approve members should redirect to member login when not logged in" do
    patch update_member_admin_path(@test.id)
    assert_redirected_to member_login_url
  end

  test "patch approve members should redirect to member mypage when logged in as normal member" do
    log_in_as_member @test
    patch update_member_admin_path(@test.id)
    assert_redirected_to member_mypage_url
  end

  test "patch approve members should admit member and redirect to approve members when logged in as admin member" do
    log_in_as_member @admin
    assert_not @test.admin
    patch update_member_admin_path(@test.id)
    assert_redirected_to member_approve_path
    @test.reload
    assert @test.admin
  end

  test "patch approve invalid member should redirect to approve members when logged in as admin member" do
    log_in_as_member @admin
    invalid_member_id = Member.maximum(:id) + 1
    patch update_member_admin_path(invalid_member_id)
    assert_redirected_to member_approve_path
  end
end
