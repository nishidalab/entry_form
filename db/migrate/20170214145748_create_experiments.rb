# 仮に作成したものなので状況に応じて勝手に置き換えてください。(okabi)

class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.string :title
      t.text :requirement
      t.text :describe

      t.timestamps
    end
  end
end
