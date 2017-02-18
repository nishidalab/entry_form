class Schedule < ApplicationRecord
  has_one :experiment
  has_one :participant

  validate :validate_experiment_id
  validate :validate_participant_id

  validates :experiment_id, presence: true
  validates :participant_id, presence: true
  validates :datetime, presence: true


  private
  # 指定されたexperiment_idのexperimentが存在するかチェック
  def validate_experiment_id
      experiment = Experiment.find_by_id(experiment_id)

      if !experiment
          errors.add(:experiment_id)
      end
  end

  # 指定されたparticipant_idのparticipantが存在するかチェック
  def validate_participant_id
      participant = Participant.find_by_id(participant_id)

      if !participant
          errors.add(:participant_id)
      end
  end

end
