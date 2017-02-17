class RenameExperimentTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :experiments, :zisshi_sekininsha, :project_owner
    rename_column :experiments, :zisshi_place, :place
    rename_column :experiments, :yosankamoku, :budget
    rename_column :experiments, :busho_code, :department_code
    rename_column :experiments, :saishu_code, :creditor_code
    rename_column :experiments, :boshu_yotei_count, :expected_participant_count
    rename_column :experiments, :zikansuu, :duration
  end
end
