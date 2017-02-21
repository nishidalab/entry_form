require 'test_helper'

class MembersRegisterTest < ActionDispatch::IntegrationTest
  test "invalid member_register information" do
    get member_register_path
    assert_no_difference 'Member.count' do
      post member_register_path, params: { member: {
          name: "", yomi: "", email: "hoge@fuga", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'members/new'
    # TODO google assert_template
    assert_select 'div#error_explanation'
  end

  test "valid member_register information" do
    get member_register_path
    assert_difference 'Member.count' do
      post member_register_path, params: { member: {
          name: "西田豊明", yomi: "にしだとよあき", email: "hoge@fuga.com",
          password: "password", password_confirmation: "password" } }
    end
  end
end
