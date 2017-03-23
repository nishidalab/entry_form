module Account
  extend ActiveSupport::Concern
  included do
    attr_accessor :remember_token, :activation_token, :reset_token
    before_create :create_activation_token_and_digest
  end

  # 渡された文字列のハッシュ値を返す
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def new_token
    SecureRandom.urlsafe_base64
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

  # パスワード再設定の期限が切れている場合は true を返す
  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  # アカウント有効化トークンの期限が切れている場合は true を返す
  def activation_token_expired?
    set_activation_token_at < 24.hours.ago
  end

  # パスワード再設定用の属性を設定する
  def create_reset_digest
    self.reset_token = self.new_token
    update(reset_digest: self.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  private

    # 有効化トークンとダイジェストを作成する。作成した時刻を記録しておく
    def create_activation_token_and_digest
      self.activation_token = self.new_token
      self.activation_digest = self.digest(activation_token)
      self.set_activation_token_at = Time.zone.now
    end

end
