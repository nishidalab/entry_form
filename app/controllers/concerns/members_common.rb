module MembersCommon
  extend ActiveSupport::Concern

  private
    # ログインしていない場合メンバーのログインページへリダイレクトする
    def redirect_to_member_login
      unless logged_in_member?
        redirect_to member_login_url
      end
    end

    # メンバーとしてログインしている場合、特定のページにリダイレクトする
    def redirect_member_logged_in(redirect_path)
      if logged_in_member?
        redirect_to redirect_path
      end
    end

end

