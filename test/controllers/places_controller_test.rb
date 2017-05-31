require 'test_helper'

class PlacesControllerTest < ActionDispatch::IntegrationTest
  test "index should redirect to member login page when not logged in" do
    get experiments_path
    assert_redirected_to member_login_url
  end

  test "new should redirect to member login page when not logged in" do
    get new_room_path
    assert_redirected_to member_login_url
  end
end
