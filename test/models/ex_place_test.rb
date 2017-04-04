require 'test_helper'

class ExPlaceTest < ActiveSupport::TestCase
  def setup
    @member = members(:one)
    @room = rooms(:one)
    @place = places(:one)
    @place2 = places(:two)
    @experiment = experiments(:one)
    @ex_place = ExPlace.new(
      experiment_id: @experiment.id,
      place_id:      @place.id)
  end

  test "should be valid" do
    assert @ex_place.valid?
  end

  test "place_id should be in Room table" do
    assert Place.find_by_id(@ex_place.place_id)
    @ex_place.place_id = Place.last.id + 1
    assert_not @ex_place.valid?
  end

  test "experiment_id should be in Experiment table" do
    assert Experiment.find_by_id(@ex_place.experiment_id)
    @ex_place.experiment_id = Experiment.last.id + 1
    assert_not @ex_place.valid?
  end

  test "(experiment_id, place_id) should be unique" do
    dup = @ex_place.dup
    @ex_place.save
    assert_not dup.valid?
    dup.place_id = @place2.id
    assert dup.valid?
  end

end
