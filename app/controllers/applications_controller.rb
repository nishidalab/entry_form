class ApplicationsController < ApplicationController
  before_action :redirect_to_login

  def index
    @participant = current_participant
    @applied_ids = Application.where(participant_id: current_participant.id).map { |a| a.schedule.experiment.id }
    @draw_experiments = []
    Experiment.find_each do |ex|
      exschedules = Schedule.where(experiment_id: ex.id)
      status = Application.where(participant_id: current_participant.id).where(schedule_id: exschedules).map{ |a| a.status }
      if !status.include?(3)
        current_ex = {}
        current_ex[:id] = ex.id
        current_ex[:name] = ex.name
        current_ex[:requirement] = ex.requirement
        current_ex[:description] = ex.description
        if status.include?(0) || status.include?(1)
          current_ex[:apply] = false
        else
          current_ex[:apply] = true
        end
        @draw_experiments.push(current_ex)
      end
    end
  end

  def new
    if params['experiment'].nil? || (@experiment = Experiment.find_by(id: params['experiment'])).nil?
      redirect_to applications_url
      return
    end
    applied_ids = Application.where(participant_id: current_participant.id).map { |a| a.schedule.experiment.id }
    exschedules = Schedule.where(experiment_id: @experiment.id)
    status = Application.where(participant_id: current_participant.id).where(schedule_id: exschedules).map{ |a| a.status }
    if applied_ids.include?(@experiment.id) && status.count != status.count(2)
      redirect_to applications_url
      return
    end
    apps = Application.where(participant_id: current_participant.id).where(status: 2).map { |a| a.schedule_id }
    @schedules = @experiment.schedules.where(participant_id: nil).where.not(id: apps)
    @times = []
    @schedules.each do |s|
      @times.push({ start: s.datetime, end: s.datetime + s.experiment.duration * 60 })
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
    ParticipantMailer.experiment_applied(current_participant, schedules).deliver_now
    MemberMailer.experiment_applied(current_participant, schedules).deliver_now
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
      redirect_to new_application_url(experiment: experiment_id)
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
        redirect_to login_url
      end
    end
end
