class Participant < ApplicationRecord
  include Account

  belongs_to :faculty
  has_many :applications, dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :schedules, through: :applications
  has_many :experiments, through: :schedules
  has_many :events, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  before_save { email.downcase! }

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :new_email, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, allow_nil: true
  validate  :validate_email_uniqueness
  validate  :validate_new_email_uniqueness
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }, allow_nil: true

  validates :name, presence: true, length: { maximum: 50 }
  validates :yomi, presence: true, length: { maximum: 50 }, format: { with: VALID_YOMI_REGEX }
  validates :gender, inclusion: { in: 1..2 }
  validates :classification, inclusion: { in: 1..3 }
  validates :grade, inclusion: { in: 1..4 }, if: Proc.new { |a| a.classification == 1 }
  validates :grade, inclusion: { in: 1..2 }, if: Proc.new { |a| a.classification == 2 }
  validates :grade, inclusion: { in: 1..3 }, if: Proc.new { |a| a.classification == 3 }
  validates :address, presence: true, length: { maximum: 255 }
  validates :agreement, acceptance: true
  validate  :validate_birth

  # 生年月日のバリデーション
  def validate_birth
    if birth.nil?
      errors.add(:birth, "を入力してください")
      return
    end

    birth_bc = birth_before_type_cast
    if birth_bc.kind_of?(Hash) # フォームで入力すると元の型がHashなのでそれを拾ってバリデーション
      y = birth_bc[1].to_i
      m = birth_bc[2].to_i
      d = birth_bc[3].to_i
      unless Date.valid_date?(y,m,d)
        errors.add(:birth, "は存在する年月日である必要があります")
      end
    end

    boundary = Date.today.years_ago(18)
    errors.add(:birth, "は#{boundary.to_s}以前である必要があります") if birth > boundary
  end

  # アクティブ被験者のメールアドレスのユニーク性バリデーション
  def validate_email_uniqueness
    # 現在登録されているメールアドレスとのユニーク性
    participant = Participant.find_by(deactivated: false, email: email.downcase)
    if participant && (id.nil? || participant.id != id)
      errors.add(:email, "は既に登録済みです")
    end

    # 更新予定のメールアドレスとのユニーク性
    participant = Participant.find_by(deactivated: false, new_email: email.downcase)
    if participant && (id.nil? || participant.id != id) && participant.email_update_token_expired?
      errors.add(:email, "は既に登録済みです")
    end
  end

  # メール更新時のメールアドレスのユニーク性を検証する
  def validate_new_email_uniqueness
    return new_email.nil?
    # 現在登録されているメールアドレスとのユニーク性
    participant = Participant.find_by(deactivated: false, email: new_email.downcase)
    if participant && (id.nil? || participant.id != id)
      errors.add(:email, "は既に登録済みです")
    end

    # 更新予定のメールアドレスとのユニーク性
    participant = Participant.find_by(deactivated: false, new_email: new_email.downcase)
    if participant && (id.nil? || participant.id != id) && participant.email_update_token_expired?
      errors.add(:email, "は既に登録済みです")
    end
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

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    ParticipantMailer.password_reset(self).deliver_now
  end

  # 性別番号を文字列に変換する
  def self.gender_to_s(gender)
    gender == 1 ? '男性' : '女性'
  end

  # メールアドレスから非退会被験者を取得する(既存メソッドのオーバーライド)
  def self.find_by_email(email)
    Participant.find_by(email: email, deactivated: false)
  end

  def self.find_active_by_new_email(new_email)
    Participant.find_by(new_email: new_email, deactivated: false)
  end

  def deactivatable?
    for s in schedules do
      if s.datetime > DateTime.now
        for a in s.applications do
          if a.status != 2
            return false
          end
        end
      end
    end
    for e in events do
      if e.start_at > DateTime.now
        return false
      end
    end
    return true
  end
end
