class Participant < ApplicationRecord
  has_many :schedules
  has_many :applications, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :schedules, through: :applications
  has_many :experiments, through: :schedules
  has_many :events, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  before_save { email.downcase! }
  before_create :create_activation_token_and_digest

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validate  :validate_email_uniqueness
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }, allow_nil: true

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

  # アクティブ被験者のメールアドレスのユニーク性バリデーション
  def validate_email_uniqueness
    participant = Participant.find_by(deactivated: false, email: email.downcase)
    errors.add(:email, "は既に登録済みです") if participant && (id.nil? || participant.id != id)
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

  # 渡されたセッショントークンがダイジェストと一致したら true を返す。
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # 渡された有効化トークンがダイジェストと一致したら true を返す。
  def activation_authenticated?(activation_token)
    return false if activation_digest.nil?
    BCrypt::Password.new(activation_digest).is_password?(activation_token)
  end

  # 渡されたパスワードリセットトークンがダイジェストと一致したら true を返す。
  def reset_authenticated?(reset_token)
    return false if reset_digest.nil?
    BCrypt::Password.new(reset_digest).is_password?(reset_token)
  end

  # 有効化トークンとダイジェストを作成する。作成した時刻を記録しておく
  def create_activation_token_and_digest
    self.activation_token = Participant.new_token
    self.activation_digest = Participant.digest(activation_token)
    self.set_activation_token_at = Time.zone.now
  end

  # パスワード再設定用の属性を設定する
  def create_reset_digest
    self.reset_token = Participant.new_token
    update(reset_digest: Participant.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    ParticipantMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合は true を返す
  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  # アカウント有効化トークンの期限が切れている場合は true を返す
  def activation_token_expired?
    set_activation_token_at < 24.hours.ago
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

  # 性別番号を文字列に変換する
  def self.gender_to_s(gender)
    gender == 1 ? '男性' : '女性'
  end

  # メールアドレスから非退会被験者を取得する(既存メソッドのオーバーライド)
  def self.find_by_email(email)
    Participant.find_by(email: email, deactivated: false)
  end
end
