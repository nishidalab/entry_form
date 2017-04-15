module SchedulesCommon
  extend ActiveSupport::Concern

  private
  def get_times(schedules, application_status)
    times = []
    schedules.each do |s|
      p_infos = []
      my_apps = Application.where(schedule_id: s.id).where(status: application_status)
      my_apps.each do |my_app|
        p_info = {}
        p = Participant.find_by_id(my_app.participant_id)
        p_info[:id] = p.id
        p_info[:name] = p.name
        p_info[:yomi] = p.yomi
        p_info[:classification] = p.classification
        p_info[:status] = my_app.status
        p_infos.push(p_info)
      end
      times.push({
        start: s.datetime,
        end: s.datetime + s.experiment.duration * 60,
        experiment: Experiment.find_by_id(s.experiment_id).name,
        p_infos: p_infos})
    end
    times
  end
end

