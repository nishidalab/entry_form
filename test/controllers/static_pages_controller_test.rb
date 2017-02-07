require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = " - Nishida Lab."
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "テストホーム" + @base_title
  end
end
