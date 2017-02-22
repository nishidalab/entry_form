require 'test_helper'

class ParticipantsInquireTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @other = participants(:two)
    @max_experiment_id = Experiment.maximum(:id)
    log_in_as_participant @participant
    ActionMailer::Base.deliveries.clear
  end

  def inquire(experiment_id, subject, body, confirming)
    post inquiries_new_path,
         params: { inquiry: { experiment_id: experiment_id, subject: subject, body: body, confirming: confirming } }
  end

  test "subject is blank" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '', '本文', '1')
    end
  end

  test "subject is too long" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, 'a' * 256, '本文', '1')
    end
  end

  test "body is blank" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '件名', '', '1')
    end
  end

  test "body is too long" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '件名', 'a' * 1024, '1')
    end
  end

  test "experiment_id is invalid" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id + 1, '件名', '本文', '1')
    end
  end

  test "valid information" do
    get inquiries_new_path
    assert_response :success
    # 「内容を確認する」
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '件名', '本文', '')
    end
    # 「送信する」
    assert_difference 'Inquiry.count', 1 do
      inquire(@max_experiment_id, '件名', '本文', '1')
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to inquiries_url
  end
end
