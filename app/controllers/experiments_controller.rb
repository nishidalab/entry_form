class ExperimentsController < ApplicationController
  include MembersCommon
  include SchedulesCommon
  before_action :redirect_to_member_login
  before_action :redirect_to_member_mypage_exclude_admin

  def index
    redirect_to member_mypage_url
  end

  def new
    @experiment = Experiment.new

    # room_idがキーで中身がdetailのハッシュテーブル作成
    h = Hash.new { |h, k| h[k] = [] }
    Place.all.each do |place|
        h[place.room_id] << {:id => place.id,:detail => place.detail}
    end
    @places = h
  end

  def create
    @member = current_member

    @experiment = Experiment.new(experiment_param_for_create)
    @experiment.member_id = @member.id

    if @experiment.save
      redirect_to member_mypage_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
    if params[:id].nil?
      redirect_to experiments_url
    end

    @member = current_member
    @experiment = Experiment.find_by_id(params[:id])

    # 自分の実験じゃない場合はマイページにリダイレクトする
    if @experiment.nil? || @member.id != @experiment.member_id
      redirect_to member_mypage_url
    else
      @times = get_times(Schedule.where(experiment_id: @experiment.id), [ApplicationStatus::APPLYING, ApplicationStatus::ACCEPTED])
    end
  end

  private
    def experiment_param_for_create
      params[:experiment][:ex_places_attributes].each { |index, hash| \
        hash[:_destroy] = hash[:place_id].blank? }
      params.require(:experiment).permit(
        :zisshi_ukagai_date, :project_owner, :room_id, :budget,
        :department_code, :project_num, :project_name, :creditor_code,
        :expected_participant_count, :duration, :name, :description,
        :schedule_from, :schedule_to, :id,
        ex_places_attributes: [
          :place_id,
          :_destroy,
        ],)
    end

end
