class Room < ApplicationRecord
  has_many :places

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validate :validate_unique_record

  def validate_unique_record
    n = name.tr('０-９ａ-ｚa-zＡ-Ｚ　ァ-ン', '0-9A-ZA-ZA-Z ぁ-ん')
    rn = Room.all.map{ |a| a.name.tr('０-９ａ-ｚa-zＡ-Ｚ　ァ-ン', '0-9A-ZA-ZA-Z ぁ-ん') }
    r = rn.include?(n)
    if r
      errors.add(:base, '既に登録されている部屋です。')
    end
  end
end
