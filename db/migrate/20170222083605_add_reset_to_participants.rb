class AddResetToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :reset_digest, :string
    add_column :participants, :reset_sent_at, :datetime
  end
end
