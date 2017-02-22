# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/experiment_applied
  def experiment_applied
    application = Application.first
    MemberMailer.experiment_applied(application.participant, [application.schedule])
  end

  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/inquired
  def inquired
    inquiry = Inquiry.first
    MemberMailer.inquired(inquiry)
  end

end
