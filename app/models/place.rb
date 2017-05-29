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
      d = detail.tr('０-９ａ-ｚa-zＡ-Ｚ　ァ-ン', '0-9A-ZA-ZA-Z ぁ-ん')
      pd = Place.where(room_id: room_id).map{ |a| a.detail.tr('０-９ａ-ｚa-zＡ-Ｚ　ァ-ン', '0-9A-ZA-ZA-Z ぁ-ん') }
      r = pd.include?(d)
      if r
        errors.add(:base, '既に登録されている場所です。')
      end
    end
end
