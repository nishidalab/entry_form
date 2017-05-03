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
    new_place_params.each do |new_place|
     split = new_place.split("=>")
     if !split[1].nil?
       if (room = Room.find_by(name: split[0])).nil?
         room = Room.create(name: split[0])
       end
       place = Place.create(room_id: room.id, detail: split[1])
       @experiment.ex_places.new(experiment_id: @experiment.id, place_id: place.id)
     end
    end
    if !params[:explaces].nil?
     explace_params[:place].each do |place|
       if place != 0
         @experiment.ex_places.new(experiment_id: @experiment.id, place_id: place)
       end
     end
    end
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
      params.require(:experiment).permit(
        :zisshi_ukagai_date, :project_owner, :room_id, :budget,
        :department_code, :project_num, :project_name, :creditor_code,
        :expected_participant_count, :duration, :name, :description,
        :schedule_from, :schedule_to, :id,
        #ex_places_attributes: [
         # :place_id,
          #:_destroy,
        #],
        )
    end
    def explace_params
     params.require(:explaces)
    end
    def new_place_params
     params.require(:place_id)
    end
end
