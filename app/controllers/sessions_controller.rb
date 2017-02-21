class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
  end

  def create
    participant = Participant.find_by(email: params[:session][:email].downcase)
    if participant && participant.authenticate(params[:session][:password])
      if participant.activated?
        log_in_participant participant
        params[:session][:remember_me] == '1' ? remember_participant(participant) : forget_participant(participant)
        redirect_back_or applications_url
      else
        flash[:warning] = 'アカウントが有効化されていません。メールを確認してください。'
        redirect_to login_url
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが違います。'
      render 'new'
    end
  end

  def destroy
    log_out_participant if logged_in_participant?
    redirect_to login_url
  end

  private

    # ログインしているか確認
    def logged_in
      if logged_in_participant?
        redirect_to mypage_url
      end
    end
end
