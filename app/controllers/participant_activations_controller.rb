class ParticipantActivationsController < ApplicationController
  def edit
    participant = Participant.find_by_email(params[:e])
    if participant && !participant.activated? && participant.activation_authenticated?(params[:t])
      participant.update(activated: true, activated_at: DateTime.now)
      log_in_participant participant
      flash[:success] = "本登録が完了しました。"
      ParticipantMailer.account_activated(participant).deliver_now
      redirect_to applications_url
    else
      flash[:danger] = "アカウントの有効化に失敗しました。"
      redirect_to login_url
    end
  end
end
