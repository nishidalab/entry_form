module MemberSessionsHelper
  # 渡された実験者でログインする
  def log_in_member(member)
    session[:member_id] = member.id
  end

  # 渡された実験者を永続的セッションに保存する
  def remember_member(member)
    member.remember
    cookies.permanent.signed[:member_id] = member.id
    cookies.permanent[:remember_token] = member.remember_token
  end

  # 永続的セッションを破棄する
  def forget_member(member)
    member.forget
    cookies.delete(:member_id)
    cookies.delete(:remember_token)
  end

  # ログインしている実験者を返す。ログインしていないなら nil を返す。
  def current_member
    if id = session[:member_id]
      @member ||= Member.find_by(id: id)
    elsif id = cookies.signed[:member_id]
      member = Member.find_by(id: id)
      if member && member.authenticated?(cookies[:remember_token])
        log_in_member member
        @member = member
      end
    end
  end

  # 実験者としてログインしていれば true を返す。
  def logged_in_member?
    !current_member.nil?
  end

  # 実験者をログアウトする。
  def log_out_member
    forget_member(@member)
    session.delete(:member_id)
    @member = nil
  end

end
