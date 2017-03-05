require 'test_helper'

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @test = participants(:one)
  end

  test "register should get register when not logged in" do
    get register_path
    assert_response :success
  end

  test "register should get mypage when logged in" do
    log_in_as_participant @test
    get register_path
    assert_redirected_to mypage_url
  end

  test "mypage should redirect to login when not logged in" do
    get mypage_path
    assert_redirected_to login_url
  end

  test "mypage should get mypage when logged in" do
    log_in_as_participant @test
    get mypage_path
    assert_template 'participants/show'
  end

  test "settings should redirect to login when not logged in" do
    get settings_path
    assert_redirected_to login_url
  end

  test "settings should get mypage when logged in" do
    log_in_as_participant @test
    get settings_path
    assert_template 'participants/edit'
  end
end
