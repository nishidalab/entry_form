# issue-1 で開発済みなのであとで置き換えるファイル

class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|

      t.timestamps
    end
  end
end
