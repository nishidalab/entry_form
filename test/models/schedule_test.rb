require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @experiment = experiments(:one)
    @schedule = Schedule.new(
      experiment_id: @experiment.id, datetime: DateTime.new(2017,3,23,10,0))
  end

  test "should be valid" do
    assert @schedule.valid?
  end

  test "experiment id should be the id of the experiment exists" do
    @schedule.experiment_id = Experiment.maximum(:id) + 1
    assert_not @schedule.valid?
  end

end
