# 仮に作成したものなので状況に応じて勝手に置き換えてください。(okabi)

class CreateSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :slots do |t|
      t.references :experiment, foreign_key: true
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
