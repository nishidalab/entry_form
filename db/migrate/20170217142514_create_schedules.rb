class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.integer :experiment_id
      t.integer :participant_id
      t.datetime :datetime

      t.timestamps
    end
  end
end
