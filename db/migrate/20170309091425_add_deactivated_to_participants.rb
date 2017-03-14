class AddDeactivatedToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :deactivated, :boolean, default: false

    # 退会した被験者が同じメールアドレスで再登録できるようにする
    remove_index :participants, :email
    add_index :participants, :email, unique: false
  end
end
