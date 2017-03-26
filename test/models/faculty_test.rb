require 'test_helper'

class FacultyTest < ActiveSupport::TestCase
  def setup
    @faculty = Faculty.new(name: "理学研究科", classification: 2)
  end
  # test "the truth" do
  #   assert true
  # end

  test "should be valid" do
    assert @faculty.valid?
  end

  test "name should be present" do
    @faculty.name = "    "
    assert_not @faculty.valid?
  end

  test "name should not be too long" do
    @faculty.name = "a" * 244
    assert_not @faculty.valid?
  end

  test "name should be unique" do
    dup = @faculty.dup
    @faculty.save
    assert_not dup.valid?
  end

  test "classification should be valid" do
    @faculty.classification = 0
    assert_not @faculty.valid? "0は有効ではない"
    @faculty.classification = 3
    assert_not @faculty.valid? "3は有効ではない"
  end
end
