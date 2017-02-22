class ParticipantMailer < ApplicationMailer
  def account_activation(participant)
    @participant = participant
    mail to: participant.email, subject: "アカウント本登録URLについて"
  end

  def account_activated(participant)
    @participant = participant
    mail to: participant.email, subject: "アカウント登録が完了しました"
  end

  def experiment_applied(participant, schedules)
    @schedules = schedules
    @experiment = schedules[0].experiment
    @participant = participant
    mail to: @participant.email, subject: "#{@experiment.name}への応募が完了しました"
  end

  def password_reset(participant)
    @participant = participant
    mail to: @participant.email, subject: "パスワードの再設定"
  end
end
