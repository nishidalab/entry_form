class Application < ApplicationRecord
  belongs_to :participant
  belongs_to :schedule

  before_save :fill_participant_id

  validate   :validate_unique_record
  validate   :validate_double_booking
  validates  :status, inclusion: { in: 0..2 }  # 0: 申請中、1: 許可、2: 拒否

  # 既存のデータが存在するか確認する(二重 post などの検証)
  def validate_unique_record
    errors.add(:base, '既に申請された内容です。') if Application.find_by(participant_id: participant_id, schedule_id: schedule_id)
  end

  # 他の application や event と被っていないかのバリデーション
  def validate_double_booking
    return if status != 1 || participant.nil? || schedule.nil?
    start_at = schedule.datetime
    end_at = start_at + schedule.experiment.duration * 60
    error = lambda { errors.add(:status, "を「承認」にできません。指定した参加者は、拘束時間中に既に確定された予定が入っています。") }
    participant.applications.where(status: 1).each do |application|
      application_start_at = application.schedule.datetime
      application_end_at = application_start_at + application.schedule.experiment.duration * 60
      if application_start_at < end_at && start_at < application_end_at
        error.call
        return
      end
    end
    participant.events.all.each do |event|
      event_start_at = event.start_at
      event_end_at = event_start_at + event.duration * 60
      if event_start_at < end_at && start_at < event_end_at
        error.call
        return
      end
    end
  end

  # status が承認されるとき schedule の participant_id を埋める
  def fill_participant_id
    if status == 1
      self.schedule.participant = participant
      self.schedule.save
    end
  end

end
