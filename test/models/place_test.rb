require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  def setup
    @room = Room.new(name: "総合研究7号館207号室")
    @place = Place.new(room_id: @room.id, detail: "ICIE1")
  end

  test "room_id should be in Room table" do
    assert !Room.find_by_id(@place.room_id).nil?
    @place.room_id = Room.last.id + 1
    assert_not @place.valid?
  end

end
