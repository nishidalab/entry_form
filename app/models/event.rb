class Event < ApplicationRecord
  belongs_to :experiment
  belongs_to :participant

  validates :name, presence: true, length: { maximum: 100 }
  validates :requirement, length: { maximum: 400 }
  validates :description, length: { maximum: 400 }
  validates :place, presence: true
  validates :start_at, presence: true
  validates :duration, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :experiment_id, presence: true
  validates :participant_id, presence: true
  validate  :validate_double_booking

  # 他の application や event と被っていないかのバリデーション
  def validate_double_booking
    return if start_at.nil? || duration.nil? || participant.nil?
    start_at = self.start_at.to_i
    end_at = (start_at + duration * 60).to_i
    error = lambda { errors.add(:start_at, "は無効です。指定した参加者は、拘束時間中に既に確定された予定が入っています。") }
    participant.applications.where(status: ApplicationStatus::ACCEPTED).each do |application|
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
