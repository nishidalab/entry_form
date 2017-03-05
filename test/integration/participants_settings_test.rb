require 'test_helper'

class ParticipantsSettingsTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  def update_profile(participant)
    patch settings_profile_path, params: { participant: {
        name: participant.name, yomi: participant.yomi, gender: participant.gender,
        classification: participant.classification, grade: participant.grade, faculty: participant.faculty,
        address: participant.address, birth: participant.birth } }
  end

  def update_password(password, password_confirmation)
    patch settings_password_path, params: { participant: {
        password: password, password_confirmation: password_confirmation } }
  end

  test "not logged in" do
    # settings_profile
    name = @participant.name
    @participant.name = "#{name}更新"
    update_profile(@participant)
    @participant.reload
    assert_equal name, @participant.name

    # settings_password
    password = @participant.password
    new_password = "#{password}changed"
    update_password(new_password, new_password)
    @participant.reload
    assert_equal password, @participant.password
  end

  test "invalid profiles" do
    log_in_as_participant @participant
    @participant.name = ""
    update_profile(@participant)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation'
  end

  test "invalid password" do
    log_in_as_participant @participant
    password = ""
    update_password(password, password)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation'
  end

  test "invalid password_confirmation" do
    log_in_as_participant @participant
    password = "#{@participant.password}changed"
    password_confirmation = @participant.password
    update_password(password, password_confirmation)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation'
  end

  test "valid profiles" do
    log_in_as_participant @participant
    name = "更新"
    yomi = "こうしん"
    gender = 2
    classification = 2
    grade = 2
    faculty = 2
    address = "更新"
    birth = "1990-12-31"
    @participant.name = name
    @participant.yomi = yomi
    @participant.gender = gender
    @participant.classification = classification
    @participant.grade = grade
    @participant.faculty = faculty
    @participant.address = address
    @participant.birth = birth
    update_profile(@participant)
    @participant.reload
    assert_equal name, @participant.name
    assert_equal yomi, @participant.yomi
    assert_equal gender, @participant.gender
    assert_equal classification, @participant.classification
    assert_equal grade, @participant.grade
    assert_equal faculty, @participant.faculty
    assert_equal address, @participant.address
    assert_equal birth, @participant.birth
    assert_template 'participants/edit'
  end

  test "valid password" do
    log_in_as_participant @participant
    password = "#{@participant.password}changed"
    update_password(password, password)
    @participant.reload
    assert_equal password, @participant.password
    assert_template 'participants/edit'
  end
end
