class Experiment < ApplicationRecord
  belongs_to :member
  belongs_to :room
  has_many :schedules, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :participants, through: :applications
  has_many :events, dependent: :destroy
  has_many :ex_places, inverse_of: :experiment
  accepts_nested_attributes_for :ex_places, allow_destroy: true

  validate :validate_schedule

  validates :member_id, presence: true
  validates :member, presence: true
  validates :project_owner, presence: true
  validates :room_id, presence: true
  validates :room, presence: true
  validates :name, uniqueness: true
  validates :budget, presence: true
  validates :department_code, presence: true
  validates :project_num, presence: true
  validates :project_name, presence: true
  validates :creditor_code, presence: true
  validates :expected_participant_count, presence: true
  validates :duration, presence: true
  validates :name, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 400 }

  private
  # 実験予定がfromからtoまでで正しい期間になっているかをチェック
  def validate_schedule
    nil_check = false
    if schedule_from.nil?
      errors.add(:schedule_from, "実験予定の開始日を入力してください")
      nil_check = true
    end
    if schedule_to.nil?
      errors.add(:schedule_to, "実験予定の終了日を入力してください")
      nil_check = true
    end
    if nil_check
      return
    end

    if schedule_from > schedule_to
      errors.add(:schedule_to, "実験予定の終了日を開始日より後にしてください。")
    end
  end
end
