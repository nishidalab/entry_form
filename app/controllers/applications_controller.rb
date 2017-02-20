class ApplicationsController < ApplicationController
  before_action :redirect_to_login

  def index
    @experiments = Experiment.all
    @participant = current_participant
    @applied_ids = Application.where(participant_id: current_participant.id).map { |a| a.schedule.experiment.id }
  end

  def new
    if params['experiment'].nil? || (@experiment = Experiment.find_by(id: params['experiment'])).nil?
      redirect_to applications_url
      return
    end
    applied_ids = Application.where(participant_id: current_participant.id).map { |a| a.schedule.experiment.id }
    if applied_ids.include?(@experiment.id)
      redirect_to applications_url
      return
    end
    @schedules = @experiment.schedules.where(participant_id: nil)
    @times = []
    @schedules.each do |s|
      @times.push({ start: s.datetime, end: s.datetime + s.experiment.duration * 3600 })
    end
    @participant = Participant.find_by(id: 1)
  end

  def create
    participant_id = current_participant.id
    experiment_id = params['experiment']
    schedule_ids = params['schedules']
    if experiment_id.nil? || schedule_ids.nil?
      create_error 'パラメータが不足しています。', experiment_id
      return
    end
    schedules = Schedule.where(id: schedule_ids)
    applications = []
    schedules.each do |schedule|
      unless schedule.participant_id.nil?
        create_error '希望日時の一部が既に埋まっています。', experiment_id
        return
      end
      a = schedule.applications.build(participant_id: participant_id, status: 0)
      unless a.valid?
        create_error '実験日時パラメータに不正なものが含まれています。', experiment_id
        return
      end
      applications.push(a)
    end
    begin
      Application.transaction do
        applications.each { |a| a.save! }
      end
    rescue
      create_error '参加申し込み受付中にエラーが発生しました。', experiment_id
      return
    end
    flash[:success] = '参加申込みを受け付けました。'
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
    def create_error(message, experiment_id)
      flash[:danger] = message
      redirect_to new_application_url + "?experiment=#{experiment_id}"
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
        redirect_to login_url
      end
    end
end
