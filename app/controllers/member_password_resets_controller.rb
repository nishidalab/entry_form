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
      @member.errors.add(:password, 'が空です。')
      render 'edit'
    elsif @member.update(member_params)
      @member.update(reset_digest: nil, reset_sent_at: nil)
      log_in_member @member
      flash[:success] = 'パスワードが更新されました。'
      redirect_to member_mypage_url
    else
      render 'edit'
    end
  end

  private

    def member_params
      params.require(:member).permit(:password, :password_confirmation)
    end

    # email パラメータから被験者を得る
    def get_member
      @member = Member.find_by_email(params[:e].downcase)
    end

    # 正しい被験者か確認する
    def valid_member
      unless (@member && @member.activated? && !@member.deactivated? && @member.reset_authenticated?(params[:id]))
        redirect_to member_login_url
      end
    end

    # 期限切れか確認する
    def check_expiration
      if @member.password_reset_expired?
        flash[:danger] = 'パスワード再設定URLの有効期限が切れています。'
        redirect_to member_reset_url
      end
    end
end
