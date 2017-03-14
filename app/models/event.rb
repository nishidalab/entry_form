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

end
