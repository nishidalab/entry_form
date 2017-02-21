# Preview all emails at http://localhost:3000/rails/mailers/participant_mailer
class ParticipantMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/participant_mailer/account_activation
  def account_activation
    participant = Participant.first
    participant.activation_token = Participant.new_token
    ParticipantMailer.account_activation(participant)
  end

  # Preview this email at http://localhost:3000/rails/mailers/participant_mailer/account_activated
  def account_activated
    participant = Participant.first
    ParticipantMailer.account_activated(participant)
  end

end
