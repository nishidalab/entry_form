class Application < ApplicationRecord
  belongs_to :participant
  belongs_to :schedule
  validate   :validate_unique_record
  validates  :status, inclusion: { in: 0..2 }  # 0: 申請中、1: 許可、2: 拒否

  # 既存のデータが存在するか確認する(二重 post などの検証)
  def validate_unique_record
    errors.add(:base, '既に申請された内容です。') if Application.find_by(participant_id: participant_id, schedule_id: schedule_id)
  end
end
