class AddEmailUpdatesToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :email_update_token, :string
    add_column :participants, :new_email, :string
  end
end
