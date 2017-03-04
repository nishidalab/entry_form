module MemberSessionsHelper
  # $BEO$5$l$?<B83<T$G%m%0%$%s$9$k(B
  def log_in_member(member)
    session[:member_id] = member.id
  end

  # $BEO$5$l$?<B83<T$r1JB3E*%;%C%7%g%s$KJ]B8$9$k(B
  def remember_member(member)
    member.remember
    cookies.permanent.signed[:member_id] = member.id
    cookies.permanent[:remember_token] = member.remember_token
  end

  # $B1JB3E*%;%C%7%g%s$rGK4~$9$k(B
  def forget_member(member)
    member.forget
    cookies.delete(:member_id)
    cookies.delete(:remember_token)
  end

  # $B%m%0%$%s$7$F$$$k<B83<T$rJV$9!#%m%0%$%s$7$F$$$J$$$J$i(B nil $B$rJV$9!#(B
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

  # $B<B83<T$H$7$F%m%0%$%s$7$F$$$l$P(B true $B$rJV$9!#(B
  def logged_in_member?
    !current_member.nil?
  end

  # $B<B83<T$r%m%0%"%&%H$9$k!#(B
  def log_out_member
    forget_member(@member)
    session.delete(:member_id)
    @member = nil
  end

end
