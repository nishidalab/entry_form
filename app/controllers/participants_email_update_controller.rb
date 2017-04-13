class ParticipantsEmailUpdateController < ApplicationController
  include AccountsCommon

  def update
    failed_email_update
  end

  private
    def failed_email_update
      flash[:danger] = "アカウントの有効化に失敗しました。"
      redirect_to participant_login_url
    end
end
