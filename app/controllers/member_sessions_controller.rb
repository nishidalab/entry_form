class MemberSessionsController < ApplicationController
# TODO TODO participant -> member
  before_action :logged_in, only: [:new, :create]

  def new
  end

  def create
    member = Member.find_by(email: params[:member_session][:email].downcase)
    if member && member.authenticate(params[:member_session][:password])
      log_in_member member
      params[:member_session][:remember_me] == '1' ? remember_member(member) : forget_member(member)
      redirect_to member_mypage_url
    else
      flash.now[:danger] = 'メールアドレスかパスワードが違います。'
      render 'new'
    end
  end

  def destroy
    log_out_member if logged_in_member?
    redirect_to member_login_url
  end

  private

    # ログインしているか確認
    def logged_in
      if logged_in_member?
        redirect_to member_mypage_url
      end
    end
end
