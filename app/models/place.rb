class Place < ApplicationRecord
  belongs_to :room

  validates :detail, length: { maximum: 50 }
  validate  :validate_unique_record
  validate  :validate_existance_of_room_id

  private
    # 既存のデータが存在するか確認する(二重 post などの検証)
    def validate_unique_record
      r = Place.find_by(room_id: room_id, detail: detail)
      if r
        errors.add(:base, '既に登録されている場所です。。')
      end
    end

    def validate_existance_of_room_id
      if Room.find_by_id(room_id).nil?
        errors.add(:base, '不正な部屋を指定しています。')
      end
    end
end
