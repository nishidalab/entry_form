class Experiment < ApplicationRecord
  belongs_to: member

  validates :validate_member_id

  validates :member_id, presence: true
  validates :project_owner, presence: true
  validates :place, presence: true
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
      member = Member.find_by_id(member_id: member_id)

      if !member
          errors.add(:member_id)
      end
  end
end
