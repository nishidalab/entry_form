class Place < ApplicationRecord
  belongs_to :room

  validates :detail, length: { maximum: 50 }
  validate   :validate_unique_record

  # 既存のデータが存在するか確認する(二重 post などの検証)
  def validate_unique_record
    r = Place.find_by(room_id: room_id, detail: detail)
    if !r.nil?
      errors.add(:base, '既に登録されている場所です。。')
    end
  end
end
