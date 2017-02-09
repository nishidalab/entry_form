class ParticipantsController < ApplicationController
  def new
    @experiment_id = params[:experiment]
    @students = view_context.options_for_select(
        { "学部生(Bachelor)" => "B",
          "修士課程(Master)" => "M",
          "博士課程(Doctor)" => "D" })
    @faculties = view_context.options_for_select(
        { "工学部" => 0,
          "理学部" => 1})
    @courses = view_context.options_for_select(
        { "情報学研究科" => 0,
          "理学研究科" => 1})
  end

  def create
    redirect_to register_url
  end
end
