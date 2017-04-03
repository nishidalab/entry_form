class MembersController < ApplicationController
  include MembersCommon
  before_action :redirect_to_member_login, only: :show
  before_action :redirect_to_member_mypage, only: [:new, :create]

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(params.require(:member).permit(
        :name, :yomi, :email,
        :password, :password_confirmation))
    if @member.save
      MemberMailer.account_activation(@member).deliver_now
      flash[:info] = "アカウント有効化のためのメールを送信しました。"
      redirect_to member_login_url
    else
      render 'new'
    end
  end

  def show
    @member = current_member
    @experiments = Experiment.where(member_id: @member.id)
    @schedules = Schedule.where(experiment_id: @experiments.ids)

    @times = []
    @schedules.each do |s|
      participant = ''
      if s.participant
        participant = s.participant.name
      else
        participant = '空き'
      end
      @times.push({
        start: s.datetime,
        end: s.datetime + s.experiment.duration * 60,
        experiment: @experiments.find_by_id(s.experiment_id).name,
        participant: participant})
    end
  end

  private

    # ログインしている場合マイページへリダイレクトする
    def redirect_to_member_mypage
      redirect_member_logged_in(member_mypage_url)
    end

end
