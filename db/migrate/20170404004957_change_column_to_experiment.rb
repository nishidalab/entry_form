class ChangeColumnToExperiment < ActiveRecord::Migration[5.0]
  def up
    change_column :experiments, :place, :integer, null: false
    rename_column :experiments, :place, :room_id
  end

  def down
    change_column :experiments, :place, :string
  end
end
