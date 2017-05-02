class ApplicationsController < ApplicationController
  before_action :redirect_to_login

  def index
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
        current_ex[:apply] = !(status.include?(ApplicationStatus::APPLYING) || status.include?(ApplicationStatus::ACCEPTED))
        @draw_experiments.push(current_ex)
      end
    end
  end

  def new
    if params['experiment'].nil? || (@experiment = Experiment.find_by(id: params['experiment'])).nil?
      redirect_to applications_url
      return
    end
    if current_participant.applications.where.not(status: ApplicationStatus::CANCELED).map { |a| a.schedule.experiment.id }.include?(@experiment.id)
      redirect_to applications_url
      return
    end
    unappliable_schedule_ids = Application.where(status: ApplicationStatus::ACCEPTED).map { |a| a.schedule.id }
    @schedules = @experiment.schedules.select { |s| !unappliable_schedule_ids.include?(s.id) }
    @times = []
    @schedules.each do |s|
      @times.push({ start: s.datetime, end: s.datetime + s.experiment.duration * 60 })
    end
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
    unappliable_schedule_ids = Application.where(status: ApplicationStatus::ACCEPTED).map { |a| a.schedule.id }
    applications = []
    schedules.each do |schedule|
      if unappliable_schedule_ids.include?(schedule.id)
        create_error '希望日時の一部が既に埋まっています。', experiment_id
        return
      end
      a = schedule.applications.build(participant_id: participant_id, status: ApplicationStatus::APPLYING)
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
