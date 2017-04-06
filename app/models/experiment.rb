class Experiment < ApplicationRecord
  belongs_to :member
  has_many :schedules, dependent: :destroy
  has_many :applications, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :participants, through: :applications
  has_many :events, dependent: :destroy
  has_many :ex_places, inverse_of: :experiment
  accepts_nested_attributes_for :ex_places, allow_destroy: true

  validate :validate_member_id
  validate :validate_room_id
  validate :validate_same_name
  validate :validate_schedule

  validates :member_id, presence: true
  validates :project_owner, presence: true
  validates :room_id, presence: true
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
  # 指定されたmember_idのmemberが存在するかチェック
  def validate_member_id
    member = Member.find_by_id(member_id)

    if !member
      errors.add(:member_id)
    end
  end

  # 指定されたroom_idのroomが存在するかチェック
  def validate_room_id
    room = Room.find_by_id(room_id)

    if !room
      errors.add(:room_id)
    end
  end

  # 同名の実験が既に存在するかをチェック
  def validate_same_name
    experiment = Experiment.find_by(name: name)

    if experiment
      errors.add(:name, "同名の実験が存在します。")
    end
  end

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
