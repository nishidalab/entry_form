class ApplicationsController < ApplicationController
  def index
    @experiments = Experiment.all
    @participant = Participant.find(1)
  end

  def new
    experiment_id = params['experiment']
    if experiment_id.nil? || Experiment.find_by(id: experiment_id).nil?
      redirect_to applications_url
      return
    end
    @experiment = Experiment.find(experiment_id)
    @slots = @experiment.slots.all
    @participant = Participant.find(1)
  end

  def create
    participant_id = 1  # テスト用
    experiment_id = params['experiment']
    slot_ids = params['slots']
    # TODO: 被験者を正しく認証できるかを確認し、認証できない場合ログインページにリダイレクトさせる
    if experiment_id.nil? || slot_ids.nil?
      create_error 'パラメータが不足しています。'
      return
    end
    experiment = Experiment.find_by(id: experiment_id)
    if experiment.nil?
      create_error '実験IDが不正です。'
      return
    end
    slot_ids.map!(&:to_i)
    applications = []
    slot_ids.each do |id|
      a = experiment.applications.build(participant_id: participant_id, slot_id: id, status: 0)
      if !a.valid?
        create_error '希望日時の一部が既に埋まっています。'
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
    flash.now[:danger] = '参加申込みを受け付けました。'
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
end
