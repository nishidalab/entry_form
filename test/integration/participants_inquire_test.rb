require 'test_helper'

class ParticipantsInquireTest < ActionDispatch::IntegrationTest
  def setup
    @participant = participants(:one)
    @other = participants(:two)
    @max_experiment_id = Experiment.maximum(:id)
    log_in_as_participant @participant
  end

  def inquire(experiment_id, body, confirming)
    post inquiries_new_path,
         params: { inquiry: { experiment_id: experiment_id, subject: '', body: body, confirming: confirming } }
  end

  test "body is blank" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '', '1')
    end
  end

  test "experiment_id is invalid" do
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id + 1, '内容', '1')
    end
  end

  test "valid information" do
    get inquiries_new_path
    assert_response :success
    # 「内容を確認する」
    assert_no_difference 'Inquiry.count' do
      inquire(@max_experiment_id, '内容', '')
    end
    # 「送信する」
    assert_difference 'Inquiry.count', 1 do
      inquire(@max_experiment_id, '内容', '1')
    end
    assert_redirected_to inquiries_url
  end
end
