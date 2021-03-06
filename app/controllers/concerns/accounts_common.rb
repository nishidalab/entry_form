# アカウント管理周りの機能をまとめる
module AccountsCommon
  extend ActiveSupport::Concern

  private
    def activate_account(user_class: nil, e: nil, t: nil)
      if user_class.nil? || e.nil? || t.nil?
        failed_activation
      else
        user = Object.const_get(user_class.capitalize).find_by_email(e)
        if user && !user.activated? && user.activation_authenticated?(t) && !user.activation_token_expired?
          user.update(activated: true, activated_at: DateTime.now)
          send("log_in_#{user_class}", user)
          flash[:success] = "本登録が完了しました。"
          Object.const_get("#{user_class.capitalize}Mailer").account_activated(user).deliver_now
          redirect_to_home user_class
        else
          failed_activation(user_class: user_class)
        end
      end
    end

    def failed_activation(user_class: '')
      flash[:danger] = "アカウントの有効化に失敗しました。"
      redirect_to eval("#{user_class}_login_url")
    end

    def password_reset(user_class:, email:)
      if user_class.nil? || email.nil?
        return nil
      else
        if user = Object.const_get(user_class.capitalize).find_by_email(email.downcase)
          user.create_reset_digest
          user.send_password_reset_email
          flash[:info] = 'パスワード再設定URLを記載したメールを送信しました。'
          return user
        else
          return nil
        end
      end
    end

    def result_password_reset(user_class:, user:)
      if user_class.nil? || user.nil?
        failed_password_reset
      else
        redirect_to eval("#{user_class}_login_url")
      end
    end

    def failed_password_reset
      flash[:danger] = 'ユーザーが見つかりません。'
      render 'new'
    end

    def redirect_to_home(user_classification)
      if user_classification == :participant && logged_in_participant?
        redirect_back_or applications_url
      elsif user_classification == :member
        if logged_in_member?
          redirect_back_or member_mypage_path
        else
          redirect_to member_login_path
        end
      else
        redirect_to login_path
      end
    end
end

