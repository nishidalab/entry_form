class Application < ApplicationRecord
  belongs_to :participant
  belongs_to :schedule

  validate   :validate_unique_record
  validate   :validate_double_booking
  validates  :status, inclusion: { in: 0..3 }  # 0: 申請中、1: 許可、2: 拒否、 3: 強い拒否

  # 既存のデータが存在するか確認する(二重 post などの検証)
  def validate_unique_record
    errors.add(:base, '既に申請された内容です。') if Application.find_by(participant_id: participant_id, schedule_id: schedule_id)
  end

  # 他の application や event と被っていないかのバリデーション
  def validate_double_booking
    return if status != 1 || participant.nil? || schedule.nil?
    start_at = schedule.datetime.to_i
    end_at = (start_at + schedule.experiment.duration * 60).to_i
    error = lambda { errors.add(:status, "を「承認」にできません。指定した参加者は、拘束時間中に既に確定された予定が入っています。") }
    participant.applications.where(status: 1).each do |application|
      application_start_at = application.schedule.datetime.to_i
      application_end_at = (application_start_at + application.schedule.experiment.duration * 60).to_i
      if application_start_at < end_at && start_at < application_end_at
        error.call
        return
      end
    end
    participant.events.all.each do |event|
      event_start_at = event.start_at.to_i
      event_end_at = (event_start_at + event.duration * 60).to_i
      if event_start_at < end_at && start_at < event_end_at
        error.call
        return
      end
    end
  end

end
