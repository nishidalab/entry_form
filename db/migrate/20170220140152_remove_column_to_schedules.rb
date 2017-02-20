class RemoveColumnToSchedules < ActiveRecord::Migration[5.0]
  def change
    remove_column :schedules, :datetime, :datetime
  end
end
