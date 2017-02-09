require 'test_helper'

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get register_path
    assert_response :success
  end
end
