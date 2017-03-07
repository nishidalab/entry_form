require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @room = Room.new(name: "総合研究7号館207号室")
  end

  test "should be valid" do
    assert @room.valid?
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

end
