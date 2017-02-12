class Participant < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  before_save { email.downcase! }

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

  # 生年月日のバリデーション
  def validate_birth
    if birth.nil?
      errors.add(:birth, "を入力してください")
      return
    end
    boundary = Date.today.years_ago(18)
    errors.add(:birth, "は#{boundary.to_s}以前である必要があります") if birth > boundary
  end

  # 永続セッションのためにトークンをデータベースに記憶する。
  def remember
    self.remember_token = Participant.new_token
    update_attribute(:remember_digest, Participant.digest(remember_token))
  end

  # 永続セッションを破棄するためにトークンをデータベースから破棄する。
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンがダイジェストと一致したら true を返す。
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
