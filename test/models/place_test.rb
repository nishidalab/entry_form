require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  def setup
    @room = Room.new(name: "hoge room")
    @room.save
    @place = Place.new(room_id: @room.id, detail: "ICIE1")
  end

  test "should be valid" do
    assert @room.valid?
    assert @place.valid?
  end

  test "room_id should be in Room table" do
    assert Room.find_by_id(@place.room_id)
    @place.room_id = Room.last.id + 1
    assert_not @place.valid?
  end

  test "(room_id, detail) should be unique" do
    dup = @place.dup
    @place.save
    assert_not dup.valid?
    dup.detail = "ICIE2"
    assert dup.valid?
  end

end
