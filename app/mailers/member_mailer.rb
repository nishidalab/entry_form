class MemberMailer < ApplicationMailer
  def account_activation(member)
    @member = member
    mail to: @member.email, subject: "アカウント本登録URLについて"
  end

  def account_activated(member)
    @member = member
    mail to: @member.email, subject: "アカウント登録が完了しました"
  end

  def password_reset(member)
    @user = member
    mail to: @user.email, subject: "パスワードの再設定"
  end

  def experiment_applied(participant, schedules)
    @participant = participant
    @schedules = schedules
    @experiment = schedules[0].experiment
    @member = @experiment.member
    mail to: @member.email, subject: "#{@experiment.name}応募(#{@participant.name})"
  end

  def inquired(inquiry)
    @inquiry = inquiry
    @participant = inquiry.participant
    @experiment = inquiry.experiment
    @member = @experiment.member
    mail to: @member.email, subject: "問い合わせ(#{@inquiry.subject})"
  end
end
