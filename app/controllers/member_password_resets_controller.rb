class MemberPasswordResetsController < ApplicationController
  include AccountsCommon
  before_action :get_member,   only: [:edit, :update]
  before_action :valid_member, only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = password_reset(user_class: :member, email: params[:password_reset][:email])
    result_password_reset(user_class: :member, user: @user)
  end

  def edit
  end

  def update
    if params[:member][:password].empty?
      @member.errors.add(:password, '$B$,6u$G$9!#(B')
      render 'edit'
    elsif @member.update(member_params)
      @member.update(reset_digest: nil, reset_sent_at: nil)
      log_in_member @member
      flash[:success] = '$B%Q%9%o!<%I$,99?7$5$l$^$7$?!#(B'
      redirect_to member_mypage_url
    else
      render 'edit'
    end
  end

  private

    def member_params
      params.require(:member).permit(:password, :password_confirmation)
    end

    # email $B%Q%i%a!<%?$+$iHo83<T$rF@$k(B
    def get_member
      @member = Member.find_by_email(params[:e].downcase)
    end

    # $B@5$7$$Ho83<T$+3NG'$9$k(B
    def valid_member
      unless (@member && @member.activated? && !@member.deactivated? && @member.reset_authenticated?(params[:id]))
        redirect_to member_login_url
      end
    end

    # $B4|8B@Z$l$+3NG'$9$k(B
    def check_expiration
      if @member.password_reset_expired?
        flash[:danger] = '$B%Q%9%o!<%I:F@_Dj(BURL$B$NM-8z4|8B$,@Z$l$F$$$^$9!#(B'
        redirect_to member_reset_url
      end
    end
end
