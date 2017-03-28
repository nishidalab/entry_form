class Member < ApplicationRecord
  include Account
  has_many :experiment

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  before_save { email.downcase! }

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness:  { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :yomi, presence: true, length: { maximum: 50 }, format: { with: VALID_YOMI_REGEX }

  # 永続セッションのためにトークンをデータベースに記憶する。
  def remember
    self.remember_token = Member.new_token
    update_attribute(:remember_digest, Member.digest(remember_token))
  end

  # 永続セッションを破棄するためにトークンをデータベースから破棄する。
  def forget
    update_attribute(:remember_digest, nil)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    MemberMailer.password_reset(self).deliver_now
  end
end
