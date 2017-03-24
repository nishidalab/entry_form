class Faculty < ApplicationRecord
  has_many :participant

  validates :name, presence: true
  validates :classification, presence: true, inclusion: { in: 1..2 }
end
