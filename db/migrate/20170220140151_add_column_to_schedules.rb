class AddColumnToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :start, :datetime
    add_column :schedules, :end, :datetime
  end
end
