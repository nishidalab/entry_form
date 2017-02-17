class Experiment < ApplicationRecord
  belongs_to: member

  validates :validate_member_id

  validates :member_id, presence: true
  validates :zisshi_sekininsha, presence: true
  validates :zisshi_place, presence: true
  validates :yosankamoku, presence: true
  validates :busho_code, presence: true
  validates :project_num, presence: true
  validates :project_name, presence: true
  validates :saishu_code, presence: true
  validates :boshu_yotei_count, presence: true
  validates :zikansuu, presence: true
  validates :name, presence: true, length: { maximum: 200 }
  validates :description, presence: true, length: { maximum: 400 }

  private
  # 指定されたmember_idのmemberが存在するかチェック
  def validate_member_id
      member = Member.find(member_id)

      if !member
          errors.add(:member_id)
      end
  end
end
