namespace :reminder do
  desc "asynchronous reminder mailing process"
  task reminder_delivery: :environment do
    applications = Application.where('schedule.datetime < ?', 1.day.since)

    applications.each do |a|
      participant = a.participant
      schedule = a.schedule
      ParticipantMailer.schedule_reminder(participant,schedule).deliver_later
    end

    events = Event.where('start_at < ?', 1.day.since)

    events.each do |e|
      participant = e.participant
      ParticipantMailer.event_reminder(participant,event).deliver_later
    end
  end
end
