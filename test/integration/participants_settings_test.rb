require 'test_helper'

class ParticipantsSettingsTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
  end

  def update_profile(participant)
    patch settings_path, params: { type: 'profile', participant: {
        name: participant.name, yomi: participant.yomi, gender: participant.gender,
        classification: participant.classification, grade: participant.grade, faculty_id: participant.faculty_id,
        address: participant.address, birth: participant.birth } }
  end

  def update_password(password, password_confirmation)
    patch settings_path, params: { type: 'password', participant: {
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
    old_password_digest = @participant.password_digest
    password = 'hogehoge'
    update_password(password, password)
    @participant.reload
    assert_equal old_password_digest, @participant.password_digest
  end

  test "invalid profiles" do
    log_in_as_participant @participant
    @participant.name = ""
    update_profile(@participant)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation', 1
  end

  test "invalid password" do
    log_in_as_participant @participant
    password = 'hoge'
    update_password(password, password)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation', 1
  end

  test "invalid password_confirmation" do
    log_in_as_participant @participant
    password = 'hogehoge'
    password_confirmation = 'fugafuga'
    update_password(password, password_confirmation)
    assert_template 'participants/edit'
    assert_select 'div#error_explanation', 1
  end

  test "valid profiles" do
    log_in_as_participant @participant
    name = '更新'
    yomi = 'こうしん'
    gender = 2
    classification = 2
    grade = 2
    faculty_id = 2
    address = '更新'
    birth = '1990-12-31'
    @participant.name = name
    @participant.yomi = yomi
    @participant.gender = gender
    @participant.classification = classification
    @participant.grade = grade
    @participant.faculty_id = faculty_id
    @participant.address = address
    @participant.birth = birth
    update_profile(@participant)
    @participant.reload
    assert_equal name, @participant.name
    assert_equal yomi, @participant.yomi
    assert_equal gender, @participant.gender
    assert_equal classification, @participant.classification
    assert_equal grade, @participant.grade
    assert_equal faculty_id, @participant.faculty_id
    assert_equal address, @participant.address
    assert_equal birth, @participant.birth.strftime('%Y-%m-%d')
    assert_template 'participants/edit'
  end

  test "valid password" do
    log_in_as_participant @participant
    password = 'hogehoge'
    update_password(password, password)
    assert_template 'participants/edit'

    # 新しいパスワードでログインできるか？
    delete logout_path
    log_in_as_participant @participant, password: password
    assert is_logged_in_participant?
  end
end
