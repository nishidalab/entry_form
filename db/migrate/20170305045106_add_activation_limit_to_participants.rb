class AddActivationLimitToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :set_activation_token_at, :datetime
  end
end
