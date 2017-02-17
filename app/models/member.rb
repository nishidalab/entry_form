class Member < ApplicationRecord
  has_many: experiment
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_YOMI_REGEX = /[ぁ-んー－\s]+/
  has_secure_password

  before_save { email.downcase! }

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness:  { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 32 }  validates :name, presence: true, length: { maximum: 50 }
  validates :yomi, presence: true, length: { maximum: 50 }, format: { with: VALID_YOMI_REGEX }

end
