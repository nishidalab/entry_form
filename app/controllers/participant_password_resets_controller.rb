class ParticipantPasswordResetsController < ApplicationController
  include AccountsCommon
  before_action :get_participant,   only: [:edit, :update]
  before_action :valid_participant, only: [:edit, :update]
  before_action :check_expiration,  only: [:edit, :update]

  def new
  end

  def create
    @user = password_reset(user_class: :participant, email: params[:password_reset][:email])
    result_password_reset(user_class: :participant, user: @user)
  end

  def edit
  end

  def update
    if params[:participant][:password].empty?
      @participant.errors.add(:password, 'が空です。')
      render 'edit'
    elsif @participant.update(participant_params)
      @participant.update(reset_digest: nil, reset_sent_at: nil)
      log_in_participant @participant
      flash[:success] = 'パスワードが更新されました。'
      redirect_to mypage_url
    else
      render 'edit'
    end
  end

  private

    def participant_params
      params.require(:participant).permit(:password, :password_confirmation)
    end

    # email パラメータから被験者を得る
    def get_participant
      @participant = Participant.find_by_email(params[:e].downcase)
    end

    # 正しい被験者か確認する
    def valid_participant
      unless (@participant && @participant.activated? && !@participant.deactivated? && @participant.reset_authenticated?(params[:id]))
        redirect_to login_url
      end
    end

    # 期限切れか確認する
    def check_expiration
      if @participant.password_reset_expired?
        flash[:danger] = 'パスワード再設定URLの有効期限が切れています。'
        redirect_to reset_url
      end
    end
end
