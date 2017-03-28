class AddDigestsToMember < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :activation_digest, :string
    add_column :members, :activated_at, :datetime
    add_column :members, :reset_digest, :string
    add_column :members, :reset_sent_at, :datetime
    add_column :members, :set_activation_token_at, :datetime
    add_column :members, :deactivated, :boolean, default: false, null:false
  end
end
