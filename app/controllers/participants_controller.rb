class ParticipantsController < ApplicationController
  before_action :redirect_to_login, only: [:show, :edit, :update, :destroy]
  before_action :redirect_to_mypage, only: [:new, :create]

  def new
    get_options_info
    @participant = Participant.new
  end

  def create
    get_options_info
    @participant = Participant.new(params.require(:participant).permit(
        :name, :yomi, :gender, :classification, :grade, :faculty_id, :address, :birth, :email,
        :password, :password_confirmation, :agreement))
    if @participant.save
      ParticipantMailer.account_activation(@participant).deliver_now
      flash[:info] = "アカウント有効化のためのメールを送信しました。"
      redirect_to login_url
    else
      render 'new'
    end
  end

  def show
    @participant = current_participant
    @applications = Application.where(participant_id: @participant.id, status: [ApplicationStatus::APPLYING, ApplicationStatus::ACCEPTED])
    @events = Event.where(participant_id: @participant.id)
  end

  def edit
    get_options_info
    @participant = current_participant
    @type = 'all'
  end

  def update
    get_options_info
    @participant = current_participant
    @type = params[:type]
    participant_params = nil
    if @type == 'profile'
      participant_params = params.require(:participant).permit(
          :name, :yomi, :gender, :classification, :grade, :faculty_id, :address, :birth)
    elsif @type == 'password'
      participant_params = params.require(:participant).permit(
          :password, :password_confirmation)
    elsif @type == 'email_update'
      participant_params = params.require(:participant).permit(:new_email)
    end
    if @participant.update_attributes(participant_params)
      flash.now[:success] = 'プロフィールを更新しました。' if @type == 'profile'
      flash.now[:success] = 'アカウント情報を更新しました。' if @type == 'password'
      if @type == 'email_update'
        @participant.create_email_update_token_and_digest
        ParticipantMailer.email_update(@participant).deliver_now
        flash.now[:info] = '新しいメールアドレスに確認メールを送信しました。'
      end
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました。' if @type == 'profile'
      flash.now[:danger] = 'アカウント情報の更新に失敗しました。' if @type == 'password'
      flash.now[:danger] = 'メールアドレスの更新に失敗しました。' if @type == 'email_update'
    end
    render 'edit'
  end

  def destroy
    @participant = current_participant
    if @participant.deactivatable? && @participant.update_attributes(deactivated: true)
      flash[:success] = 'アカウントを削除しました。'
    else
      flash[:danger] = 'アカウントの削除に失敗しました。'
    end
    log_out_participant
    redirect_to login_url
  end

  private

    def get_options_info
      @classifications = {
          "学部生(Bachelor)" => 1,
          "修士課程(Master)" => 2,
          "博士課程(Doctor)" => 3 }
      @faculties = Faculty.where("classification == ?",1).pluck(:name,:id)
      @courses = Faculty.where("classification == ?",2).pluck(:name,:id)
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
        store_location
        redirect_to login_url
      end
    end

    # ログインしている場合マイページへリダイレクトする
    def redirect_to_mypage
      if logged_in_participant?
        redirect_to mypage_url
      end
    end
end
