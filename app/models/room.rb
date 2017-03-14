class Room < ApplicationRecord
  has_many :places

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
