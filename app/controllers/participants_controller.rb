class ParticipantsController < ApplicationController
  before_action :redirect_to_login, only: :show
  before_action :redirect_to_mypage, only: [:new, :create]

  def new
    get_options_info
    @participant = Participant.new
  end

  def create
    get_options_info
    @participant = Participant.new(params.require(:participant).permit(
        :name, :yomi, :gender, :classification, :grade, :faculty, :address, :birth, :email,
        :password, :password_confirmation))
    if @participant.save
      redirect_to login_url
    else
      render 'new'
    end
  end

  def show
    @participant = current_participant
    @applications = Application.where(participant_id: @participant.id, status: 0..1)
  end

  private

    def get_options_info
      @classifications = {
          "学部生(Bachelor)" => 1,
          "修士課程(Master)" => 2,
          "博士課程(Doctor)" => 3 }
      @faculties = {
          "工学部" => 1,
          "理学部" => 2}
      @courses = {
          "情報学研究科" => 1,
          "理学研究科" => 2}
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
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
