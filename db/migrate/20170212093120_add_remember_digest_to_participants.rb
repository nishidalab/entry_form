class AddRememberDigestToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :remember_digest, :string
  end
end
