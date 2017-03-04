class MemberSessionsController < ApplicationController
# TODO TODO participant -> member
  before_action :logged_in, only: [:new, :create]

  def new
  end

  def create
    member = Member.find_by(email: params[:session][:email].downcase)
    if member && member.authenticate(params[:session][:password])
      log_in_member member
      params[:session][:remember_me] == '1' ? remember_member(member) : forget_member(member)
      redirect_to member_mypage_url
    else
      flash.now[:danger] = '$B%a!<%k%"%I%l%9$+%Q%9%o!<%I$,0c$$$^$9!#(B'
      render 'new'
    end
  end

  def destroy
    log_out_member if logged_in_member?
    redirect_to member_login_url
  end

  private

    # $B%m%0%$%s$7$F$$$k$+3NG'(B
    def logged_in
      if logged_in_member?
        redirect_to member_mypage_url
      end
    end
end
