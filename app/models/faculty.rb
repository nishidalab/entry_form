class Faculty < ApplicationRecord
  has_many :participant

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :classification, inclusion: { in: 1..2 }
end
