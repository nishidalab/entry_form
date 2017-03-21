require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  def setup
    @member = Member.new(name: 'ラボ員', yomi: 'らぼいん', email: 'member@example.com', password: 'password')
  end

  test "should be valid" do
    assert @member.valid?
  end

  test "email should be present" do
    @member.email = "    "
    assert_not @member.valid?
  end

  test "email should not be too long" do
    @member.email = "a" * 244 + "@example.com"
    assert_not @member.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @member.email = valid_address
      assert @member.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @member.email = invalid_address
      assert_not @member.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email in active members should be unique" do
    # アクティブな実験者と同一のメールアドレスでは登録できない
    dup = @member.dup
    dup.email.upcase!
    @member.save
    assert_not dup.valid?

    # 退会済み被験者と同一のメールアドレスでは登録できる
    #@member.deactivated = true
    #@member.save
    #assert dup.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "Foo@Bar.CoM"
    @member.email = mixed_case_email
    @member.save
    assert_equal mixed_case_email.downcase, @member.reload.email
  end

  test "password should be present" do
    @member.password = @member.password_confirmation = " " * 8
    assert_not @member.valid?
  end

  test "password should have minimum length" do
    @member.password = @member.password_confirmation = "a" * 7
    assert_not @member.valid?
  end

  test "password should not be too long" do
    @member.password = @member.password_confirmation = "a" * 33
    assert_not @member.valid?
  end

  test "name should be present" do
    @member.name = "    "
    assert_not @member.valid?
  end

  test "name should not be too long" do
    @member.name = "a" * 51
    assert_not @member.valid?
  end

  test "yomi should be present" do
    @member.yomi = "    "
    assert_not @member.valid?
  end

  test "yomi should not be too long" do
    @member.name = "あ" * 51
    assert_not @member.valid?
  end

  test "yomi should accept Hiragana strings" do
    valid_yomis = %w[にしだ なかざわ ぴよ]
    valid_yomis.each do |valid_yomi|
      @member.yomi = valid_yomi
      assert @member.valid?, "#{valid_yomi.inspect} should be valid"
    end
  end

  test "yomi should reject not-Hiragana strings" do
    invalid_yomis = %w[ニシダ 中澤 ほげホゲ fugafuga]
    invalid_yomis.each do |invalid_yomi|
      @member.email = invalid_yomi
      assert_not @member.valid?, "#{invalid_yomi.inspect} should be invalid"
    end
  end
end
