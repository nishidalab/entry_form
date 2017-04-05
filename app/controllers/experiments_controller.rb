class ExperimentsController < ApplicationController
  include MembersCommon
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

    @experiment = Experiment.new(params.require(:experiment).permit(
      :zisshi_ukagai_date, :project_owner, :room_id, :budget,
      :department_code, :project_num, :project_name, :creditor_code,
      :expected_participant_count, :duration, :name, :description,
      :schedule_from, :schedule_to, :id,
      ex_places: [
        :place_id,
      ],))
    @experiment.member_id = @member.id

    logger.debug(params.require(:experiment))

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
    end
  end


end
