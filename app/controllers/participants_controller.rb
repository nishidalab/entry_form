class ParticipantsController < ApplicationController

  def new
    get_options_info
    @participant = Participant.new
  end

  def create
    get_options_info
    @participant = Participant.new(params.require(:participant).permit(
        :name, :yomi, :gender, :classification, :grade, :faculty, :address, :birth, :email,
        :password, :password_confirmation))
    if @participant.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def get_options_info
      @classifications = {
          "学部生(Bachelor)" => 1,
          "修士課程(Master)" => 2,
          "博士課程(Doctor)" => 3 }
      @faculties = {
          "工学部" => 1,
          "理学部" => 2}
      @courses = {
          "情報学研究科" => 1,
          "理学研究科" => 2}
    end
end
