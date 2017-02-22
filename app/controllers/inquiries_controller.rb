class InquiriesController < ApplicationController
  before_action :redirect_to_login

  def index
    @inquiries = current_participant.inquiries.order("created_at DESC")
  end

  def show
    @inquiry = Inquiry.find_by_id(params[:id])
    if @inquiry.nil? || current_participant != @inquiry.participant
      redirect_to inquiries_url
      return
    end
    @experiment = @inquiry.experiment
    @participant = @inquiry.participant
  end

  def new
    @experiments = Experiment.all.map { |e| ["#{e.name}", e.id] }
    @inquiry = Inquiry.new(participant_id: current_participant.id)
  end

  def create
    @experiments = Experiment.all.map { |e| ["#{e.name}", e.id] }
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.participant_id = current_participant.id

    respond_to do |format|
      if @inquiry.save
        MemberMailer.inquired(@inquiry).deliver_now
        format.html do
          flash[:info] = 'お問い合わせを送信しました。'
          redirect_to inquiries_url
        end
      else
        @experiment_name = @inquiry.experiment.name unless @inquiry.experiment.nil?
        format.html do
          render 'new'
        end
      end
    end
  end

  private

    def inquiry_params
      params.require(:inquiry).permit(:experiment_id, :subject, :body, :confirming)
    end

    # ログインしていない場合ログインページへリダイレクトする
    def redirect_to_login
      unless logged_in_participant?
        store_location
        redirect_to login_url
      end
    end
end
