require 'test_helper'

class ParticipantTest < ActiveSupport::TestCase
  def setup
    @participant = Participant.new(
        email: "test@example.com", name: "test試験", yomi: "てすと",  gender: 1, birth: Date.new(1990, 1, 1),
        classification: 1, grade: 1, faculty: 1, address: "京都市左京区吉田本町",
        password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @participant.valid?
  end

  test "email should be present" do
    @participant.email = "    "
    assert_not @participant.valid?
  end

  test "email should not be too long" do
    @participant.email = "a" * 244 + "@example.com"
    assert_not @participant.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @participant.email = valid_address
      assert @participant.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @participant.email = invalid_address
      assert_not @participant.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be unique" do
    dup = @participant.dup
    dup.email.upcase!
    @participant.save
    assert_not dup.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "Foo@Bar.CoM"
    @participant.email = mixed_case_email
    @participant.save
    assert_equal mixed_case_email.downcase, @participant.reload.email
  end

  test "password should be present" do
    @participant.password = @participant.password_confirmation = " " * 8
    assert_not @participant.valid?
  end

  test "password should have minimum length" do
    @participant.password = @participant.password_confirmation = "a" * 7
    assert_not @participant.valid?
  end

  test "password should not be too long" do
    @participant.password = @participant.password_confirmation = "a" * 33
    assert_not @participant.valid?
  end

  test "name should be present" do
    @participant.name = "    "
    assert_not @participant.valid?
  end

  test "name should not be too long" do
    @participant.name = "a" * 51
    assert_not @participant.valid?
  end

  test "yomi should be present" do
    @participant.yomi = "    "
    assert_not @participant.valid?
  end

  test "yomi should not be too long" do
    @participant.name = "あ" * 51
    assert_not @participant.valid?
  end

  test "yomi should accept Hiragana strings" do
    valid_yomis = %w[にしだ なかざわ ぴよ]
    valid_yomis.each do |valid_yomi|
      @participant.yomi = valid_yomi
      assert @participant.valid?, "#{valid_yomi.inspect} should be valid"
    end
  end

  test "yomi should reject not-Hiragana strings" do
    invalid_yomis = %w[ニシダ 中澤 ほげホゲ fugafuga]
    invalid_yomis.each do |invalid_yomi|
      @participant.email = invalid_yomi
      assert_not @participant.valid?, "#{invalid_yomi.inspect} should be invalid"
    end
  end

  test "gender should accept valid value" do
    @participant.gender = 1
    assert @participant.valid?
  end

  test "gender should reject invalid value" do
    @participant.gender = 0
    assert_not @participant.valid?
  end

  test "birth should be present" do
    @participant.birth = nil
    assert_not @participant.valid?
  end

  test "birth should accept 18 years ago date" do
    @participant.birth = Date.today.years_ago(18)
    assert @participant.valid?
  end

  test "birth should reject (18 years - 1 date) ago date" do
    @participant.birth = Date.today.years_ago(18) + 1
    assert_not @participant.valid?
  end

  test "classification should be valid" do
    @participant.classification = 0
    assert_not @participant.valid?, "0は有効な値ではない"
    @participant.classification = 4
    assert_not @participant.valid?, "4は有効な値ではない"
  end

  test "grade should be valid" do
    @participant.grade = 0
    assert_not @participant.valid?, "0は有効な値ではない"
    @participant.classification = 1
    @participant.grade = 5
    assert_not @participant.valid?, "学部5年生は有効な値ではない"
    @participant.classification = 2
    @participant.grade = 3, "修士課程3年生は有効な値ではない"
    assert_not @participant.valid?
    @participant.classification = 3
    @participant.grade = 4
    assert_not @participant.valid?, "博士課程4年生は有効な値ではない"
  end

  test "faculty should be present" do
    @participant.faculty = 0
    assert_not @participant.valid?
  end

  test "address should be present" do
    @participant.address = "    "
    assert_not @participant.valid?
  end

  test "address should not be too long" do
    @participant.address = "あ" * 256
    assert_not @participant.valid?
  end
end
