class PlacesController < ApplicationController
  include MembersCommon
  before_action :redirect_to_member_login
  before_action :redirect_to_member_mypage_exclude_admin

  def index
    redirect_to member_mypage_url
  end

  def new
    @room = Room.new
    @place = Place.new
  end

  def create
    @type = params[:type]
    if @type == 'place'
      @place = Room.find(params[:place][:room_id]).places.build(params.require(:place).permit(:room_id, :detail))
      if @place.save
        flash[:info] = "場所を追加しました。"
        redirect_to new_room_url
      else
        @room = Room.new
        render 'new'
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end
end
