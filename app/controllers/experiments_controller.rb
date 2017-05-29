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
    @experiment.ex_places.build # place情報追加用
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

  def newroom
    @room = Room.new
    @place = Place.new
  end

  def createroom
    @type = params[:type]
    if @type == 'room'
      @room = Room.new(params.require(:room).permit(:name))
      if @room.save
        flash[:info] = "部屋を追加しました。"
        redirect_to experiment_newroom_url
      else
        @place = Place.new
        render 'newroom'
      end
    end
    if @type == 'place'
      @place = Room.find(params[:place][:room_id]).places.build(params.require(:place).permit(:room_id, :detail))
      if @place.save
        flash[:info] = "場所を追加しました。"
        redirect_to experiment_newroom_url
      else
        @room = Room.new
        render 'newroom'
      end
    end
  end

  private
    def experiment_param_for_create
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
