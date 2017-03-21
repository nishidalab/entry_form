require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @participant = participants(:one)
    @experiment = experiments(:one)
    @schedule = Schedule.new(
      experiment_id: @experiment.id, participant_id: @participant.id,
      datetime: DateTime.new(2017,3,23,10,0))
  end

  test "should be valid" do
    assert @schedule.valid?
  end

  test "experiment id should be the id of the experiment exists" do
    @schedule.experiment_id = Experiment.maximum(:id) + 1
    assert_not @schedule.valid?
  end

  test "participant id should be the id of the participant exists" do
    @schedule.participant_id = Participant.maximum(:id) + 1
    assert_not @schedule.valid?
  end

end
