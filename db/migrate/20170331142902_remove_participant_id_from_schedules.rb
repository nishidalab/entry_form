class RemoveParticipantIdFromSchedules < ActiveRecord::Migration[5.0]
  def change
    remove_column :schedules, :participant_id
  end
end
