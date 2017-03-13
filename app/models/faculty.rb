class Faculty < ApplicationRecord
  has_many :participant

  validates :name, presence: true
end
