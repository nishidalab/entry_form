class Place < ApplicationRecord
  belongs_to :room
  has_many :ex_places

  validates :detail, length: { maximum: 50 }
  validates :room_id, presence: true
  validates :room, presence: true
  validate  :validate_unique_record

  private
    # 既存のデータが存在するか確認する(二重 post などの検証)
    def validate_unique_record
      r = Place.find_by(room_id: room_id, detail: detail)
      if r
        errors.add(:base, '既に登録されている場所です。。')
      end
    end
end
