class CreateExPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :ex_places do |t|
      t.integer :experiment_id, null: false
      t.integer :place_id,      null: false

      t.timestamps
    end
  end
end
