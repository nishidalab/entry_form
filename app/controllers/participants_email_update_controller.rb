class ParticipantsEmailUpdateController < ApplicationController
  include AccountsCommon

  def update
    new_email = params[:e].downcase
    token = params[:t]
    participant = Participant.find_active_by_new_email(new_email)
    if participant.email_update_authenticated?(token)
      participant.update(email: new_email,new_email: nil)
      log_in_participant(participant)
      flash[:success] = "メールアドレスの更新に成功しました。"
      redirect_to applications_url
    else
      failed_email_update
    end
  end

  private
    def failed_email_update
      flash[:danger] = "メールアドレスの更新に失敗しました"
      redirect_to participant_login_url
    end
end
