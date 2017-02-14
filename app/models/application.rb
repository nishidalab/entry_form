class Application < ApplicationRecord
  belongs_to :experiment
  belongs_to :participant
  belongs_to :slot
end
