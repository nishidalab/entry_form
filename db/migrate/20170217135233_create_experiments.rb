class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.integer :member_id
      t.date :zisshi_ukagai_date
      t.string :zisshi_sekininsha
      t.string :zisshi_place
      t.string :yosankamoku
      t.string :busho_code
      t.string :project_num
      t.string :project_name
      t.string :saishu_code
      t.integer :boshu_yotei_count
      t.integer :zikansuu
      t.string :name
      t.string :description
      t.date :schedule_from
      t.date :schedule_to
      t.date :final_report_date

      t.timestamps
    end
  end
end
