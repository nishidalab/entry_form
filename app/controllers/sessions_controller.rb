class SessionsController < ApplicationController
  before_action :logged_in, only: [:new_participant, :new_member, :create_participant, :create_member]

  def new_participant
    new('Participant', :participant)
  end

  def new_member
    new('Member', :member)
  end

  def new(model_class, user_classification)
    @user_class = user_classification
    render 'new'
  end

  def create_participant
    create('Participant', :participant)
  end

  def create_member
    create('Member', :member)
  end

  def create(model_class, user_classification)
    user = Object.const_get(model_class).find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user_classification == :member || user.activated?
        self.send("log_in_#{user_classification}", user)
        params[:session][:remember_me] == '1' ? self.send("remember_#{user_classification}", user) : self.send("forget_#{user_classification}", user)
        if user_classification == :participant
          redirect_back_or applications_url
        elsif user_classification == :member
          redirect_to member_mypage_path
        end
      else
        flash[:warning] = 'アカウントが有効化されていません。メールを確認してください。'
        redirect_to eval("#{user_classification}_login_path")
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが違います。'
      render 'new'
    end
  end

  def destroy_participant
    destroy('Participant', :participant)
  end

  def destroy_member
    destroy('Member', :member)
  end

  def destroy(model_class, user_classification)
    self.send("log_out_#{user_classification}") if self.send("logged_in_#{user_classification}?")
    redirect_to self.send("#{user_classification}_login_url")
  end

  private

    # ログインしているか確認
    def logged_in
      if logged_in_participant?
        redirect_to mypage_url
      elsif logged_in_member?
        redirect_to member_mypage_url
      end
    end
end
