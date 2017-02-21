class Inquiry < ApplicationRecord
  belongs_to :participant
  belongs_to :experiment

  validate :validate_participant_id
  validate :validate_experiment_id
  validates :subject, length: { maximum: 255 }
  validates :body, length: { maximum: 1023 }, presence: true

  validates_acceptance_of :confirming
  after_validation :check_confirming

  def check_confirming
    errors.delete(:confirming)
    self.confirming = errors.empty? ? '1' : ''
  end

  private

    # 指定されたparticipant_idのparticipantが存在するかチェック
    def validate_participant_id
      errors.add(:participant_id) unless Participant.find_by_id(participant_id)
    end

    # 指定されたexperiment_idのexperimentが存在するかチェック
    def validate_experiment_id
      errors.add(:experiment_id) unless Experiment.find_by_id(experiment_id)
    end

end
