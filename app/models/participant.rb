class Participant < ApplicationRecord
  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness:  { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :yomi, presence: true, length: { maximum: 50 }, format: { with: VALID_YOMI_REGEX }
  validates :gender, inclusion: { in: 1..2 }
  validates :classification, inclusion: { in: 1..3 }
  validates :grade, inclusion: { in: 1..4 }, if: Proc.new { |a| a.classification == 1 }
  validates :grade, inclusion: { in: 1..2 }, if: Proc.new { |a| a.classification == 2 }
  validates :grade, inclusion: { in: 1..3 }, if: Proc.new { |a| a.classification == 3 }
  validates :faculty, inclusion: { in: 1..3 }
  validates :address, presence: true, length: { maximum: 255 }
  validate  :validate_birth

  def validate_birth
    if birth.nil?
      errors.add(:birth, "birth should be present")
      return
    end
    boundary = Date.today.years_ago(18)
    errors.add(:birth, "birth should be former than #{boundary}") if birth > boundary
  end
end
