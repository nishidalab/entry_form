require 'test_helper'

class ExperimentTest < ActiveSupport::TestCase
  def setup
    @member = Member.new(name: 'ラボ員', yomi: 'らぼいん', email: 'member@ii.ist.i.kyoto-u.ac.jp', password: 'password')
    @member.save
    @room = rooms(:one)
    @room.save
    @experiment = Experiment.new(
      member_id: @member.id, zisshi_ukagai_date: Date.new(2017, 3, 23),
      project_owner: 'プロ主', room_id: @room.id, budget: 'あの金',
      department_code: 'hoge1234', project_num: 'z1234',
      project_name: 'ほげプロ', creditor_code: 'Z9876',
      expected_participant_count: 24, duration: 2,
      name: 'hoge exp', description: 'これをああする',
      schedule_from: Date.new(2017, 3, 24),
      schedule_to: Date.new(2017, 3, 30))
    @member_max_id = Member.maximum(:id)
    @room_max_id = Room.maximum(:id)
  end

  test "should be valid" do
    assert @experiment.valid?
  end

  test "name should be present" do
    @experiment.name = "    "
    assert_not @experiment.valid?
  end

  test "name should not be too long" do
    @experiment.name = "a" * 201
    assert_not @experiment.valid?
  end

  test "description should be present" do
    @experiment.description = "    "
    assert_not @experiment.valid?
  end

  test "description should not be too long" do
    @experiment.description = "a" * 401
    assert_not @experiment.valid?
  end

  test "name should be unique" do
    dup = @experiment.dup
    @experiment.save
    assert_not dup.valid?
    dup.name = dup.name + 'hoge'
    assert dup.valid?
  end

  test "schedule from shoud be leq schedule to" do
    @experiment.schedule_to = @experiment.schedule_from
    assert @experiment.valid?
    @experiment.schedule_to = @experiment.schedule_from.yesterday
    assert_not @experiment.valid?
  end

  test "member id should be the id of the member exists" do
    @experiment.member_id = @member_max_id + 1
    assert_not @experiment.valid?
  end

  test "room id should be the id of the room exists" do
    @experiment.room_id = @room_max_id + 1
    assert_not @experiment.valid?
  end

end
