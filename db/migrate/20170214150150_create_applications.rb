class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.references :experiment, foreign_key: true, options: 'ON UPDATE CASCADE ON DELETE CASCADE'
      t.references :participant, foreign_key: true, options: 'ON UPDATE CASCADE ON DELETE CASCADE'
      t.references :slot, foreign_key: true, options: 'ON UPDATE CASCADE ON DELETE CASCADE'
      t.integer :status

      t.timestamps
    end
  end
end
