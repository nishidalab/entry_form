class ApplicationsController < ApplicationController
  before_action :redirect_to_login

  def index
    @experiments = Experiment.all
    @participant = current_participant
  end

  def new
    experiment_id = params['experiment']
    if experiment_id.nil? || Experiment.find_by(id: experiment_id).nil?
      redirect_to applications_url
      return
    end
    @experiment = Experiment.find_by(id: experiment_id)
    @schedules = @experiment.schedules.all
    @schedules.each_with_index do |s, idx|
      @schedules[idx]['start'] = s.datetime
      @schedules[idx]['end']   = s.datetime + Rational(s.experiment.duration, 24)
    end
    @participant = Participant.find_by(id: 1)
  end

  def create
    participant_id = current_participant.id
    schedule_ids = params['schedules']
    if schedule_ids.nil?
      create_error '実験日時パラメータがありません。'
      return
    end
    schedules = Schedule.where(id: schedule_ids.map(&:to_i))
    applications = []
    schedules.each do |schedule|
      unless schedule.participant_id.nil?
        create_error '希望日時の一部が既に埋まっています。'
        return
      end
      a = schedule.applications.build(participant_id: participant_id, schedule_id: schedule.id, status: 0)
      unless a.valid?
        create_error '実験日時パラメータに不正なものが含まれています。'
        return
      end
      applications.push(a)
    end
    begin
      Application.transaction do
        applications.each { |a| a.save! }
      end
    rescue
      create_error '参加申し込み受付中にエラーが発生しました。'
      return
    end
    flash.now[:success] = '参加申込みを受け付けました。'
    redirect_to applications_url
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    # create アクションでのエラー
    def create_error(message)
      flash.now[:danger] = message
      redirect_to new_application_url
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
        redirect_to login_url
      end
    end
end
