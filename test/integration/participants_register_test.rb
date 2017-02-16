require 'test_helper'

class ParticipantsRegisterTest < ActionDispatch::IntegrationTest
  test "invalid register information" do
    get register_path
    assert_no_difference 'Participant.count' do
      post register_path, params: { participant: {
          name: "", yomi: "", gender: 1, classification: 1, grade: 1, faculty: 1, address: "",
          birth: "2100-01-01", email: "hoge@fuga", password: "foo", password_confirmation: "bar" } }
    end
    assert_template 'participants/new'
    assert_select 'div#error_explanation'
  end

  test "valid register information" do
    get register_path
    assert_difference 'Participant.count' do
      post register_path, params: { participant: {
          name: "西田豊明", yomi: "にしだとよあき", gender: 1, classification: 1, grade: 1, faculty: 1,
          address: "京都市左京区吉田本町", birth: "1995-01-01", email: "hoge@fuga.com",
          password: "password", password_confirmation: "password" } }
    end
  end
end
