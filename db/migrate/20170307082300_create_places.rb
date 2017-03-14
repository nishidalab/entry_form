class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.integer :room_id
      t.string :detail

      t.timestamps
    end
  end
end
