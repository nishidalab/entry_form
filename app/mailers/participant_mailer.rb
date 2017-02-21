class ParticipantMailer < ApplicationMailer
  def account_activation(participant)
    @participant = participant
    mail to: participant.email, subject: "アカウント本登録URLについて"
  end

  def account_activated(participant)
    @participant = participant
    mail to: participant.email, subject: "アカウント登録が完了しました"
  end
end
