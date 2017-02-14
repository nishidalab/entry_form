class Application < ApplicationRecord
  belongs_to :experiment
  belongs_to :participant
  belongs_to :slot
  validate   :validate_unique_record

  # 既存のデータが存在するか確認する(二重 post などの検証)
  def validate_unique_record
    r = Application.find_by(
        experiment_id: experiment_id, participant_id: participant_id, slot_id: slot_id)
    if !r.nil?
      errors.add(:base, '既に申請された内容です。')
    end
  end
end
