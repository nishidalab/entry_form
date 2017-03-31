class Schedule < ApplicationRecord
  belongs_to :experiment
  has_many :applications

  validate :validate_experiment_id

  validates :experiment_id, presence: true
  validates :datetime, presence: true


  private
  # 指定されたexperiment_idのexperimentが存在するかチェック
  def validate_experiment_id
    experiment = Experiment.find_by_id(experiment_id)

    if !experiment
      errors.add(:experiment_id)
    end
  end

end
