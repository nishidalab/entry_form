require 'test_helper'

class MembersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @member = members(:one)
    @admin = members(:admin)
  end

  test "login with remembering" do
    log_in_as_member @member, remember_me: '1'
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as_member @member, remember_me: '0'
    assert_nil cookies['remember_token']
  end
end
