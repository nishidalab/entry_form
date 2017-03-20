require 'test_helper'

class ExperimentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test = members(:one)
  end

  test "member register should get member register when not logged in" do
    get member_register_path
    assert_response :success
  end

  test "member register should get member mypage when logged in" do
    log_in_as_member @test
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
  end
end
