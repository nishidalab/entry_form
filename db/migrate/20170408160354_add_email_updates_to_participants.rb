class AddEmailUpdatesToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :email_update_digest, :string
    add_column :participants, :set_email_update_at, :datetime
    add_column :participants, :new_email, :string
  end
end
