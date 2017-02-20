class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.references :participant, foreign_key: true, null: false, options: 'ON UPDATE CASCADE ON DELETE CASCADE'
      t.references :schedule, foreign_key: true, null: false, options: 'ON UPDATE CASCADE ON DELETE CASCADE'
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
