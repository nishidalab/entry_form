class MemberMailer < ApplicationMailer
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
