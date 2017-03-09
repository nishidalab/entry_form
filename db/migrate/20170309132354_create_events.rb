class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :requirement
      t.text :description
      t.string :place
      t.datetime :start_at
      t.integer :duration
      t.integer :experiment_id
      t.integer :participant_id

      t.timestamps
    end
    add_index :events, :experiment_id
    add_index :events, :participant_id
  end
end
