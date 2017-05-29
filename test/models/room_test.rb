require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @room = Room.new(name: "総合研究7号館207号室")
    @room1 = Room.new(name: "1１ ぁァあアがガぱパ　ｓsＳS")
  end

  test "should be valid" do
    assert @room.valid?
    assert @room1.valid?
  end

  test "name should be present" do
    @room.name = "    "
    assert_not @room.valid?
  end

  test "name should not be too long" do
    @room.name = "a" * 244
    assert_not @room.valid?
  end

  test "name should be unique" do
    dup = @room.dup
    @room.save
    assert_not dup.valid?
  end

  test "name should be unique regardless of hiragana, katakana, etc" do
    dup = @room1.dup
    @room1.save
    dup.name = "１1　ァぁアあガがパぱ ＳSｓs"
    assert_not dup.valid?
  end

end
