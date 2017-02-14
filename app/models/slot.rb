class Slot < ApplicationRecord
  belongs_to :experiment
  has_many :applications, dependent: :destroy
  has_one :participant, through: :applications
end
