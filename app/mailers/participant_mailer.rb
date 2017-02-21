class ParticipantMailer < ApplicationMailer
  def account_activation(participant)
    @participant = participant
    mail to: participant.email, subject: "アカウント本登録URLについて"
  end
end
