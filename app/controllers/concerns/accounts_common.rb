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
          redirect_to applications_url
        else
          failed_activation(user_class: user_class)
        end
      end
    end

    def failed_activation(user_class: '')
      flash[:danger] = "アカウントの有効化に失敗しました。"
      redirect_to eval("#{user_class}_login_url")
    end
end

