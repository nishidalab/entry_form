class AddActivationToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :activation_digest, :string
    add_column :participants, :activated, :boolean, default: false
    add_column :participants, :activated_at, :datetime
  end
end
