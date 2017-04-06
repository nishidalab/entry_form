class ExPlace < ApplicationRecord
  belongs_to :experiment, inverse_of: :ex_places
  belongs_to :place

  validate :validate_place_id
  #validate :validate_unique_record

  #validates :experiment_id, presence: true
  validates :place_id, presence: true

  private
    # 指定されたplace_idのplaceが存在するかチェック
    def validate_place_id
      place = Place.find_by_id(place_id)

      if !place
        errors.add(:place_id)
      end
    end

    # 既存のデータが存在するか確認する(二重 post などの検証)
    def validate_unique_record
      r  = ExPlace.find_by(experiment_id: experiment_id, place_id: place_id)
      if r
        errors.add(:base, '既に登録されている場所です。。')
      end
    end
end
