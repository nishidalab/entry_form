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
    @user = participant
    mail to: @user.email, subject: "パスワードの再設定"
  end

  def email_update(participant)
    @participant = participant
    mail to: @participant.new_email, subject: "メールアドレスの更新"
  end

  def schedule_reminder(participant,schedule)
    @participant = participant
    @schedule = schedule
    mail to: @participant.email, subject: "【リマインダ】明日、#{@schedule.experiment.name}が予定されています。"
  end

  def event_reminder(participant,event)
    @participant = participant
    @event = event
    mail to: @participant.email, subject: "【リマインダ】明日、#{@event.experiment.name}の#{@event.name}が予定されています。"
  end
end
