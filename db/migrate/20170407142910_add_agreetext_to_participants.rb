class AddAgreetextToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :agreetext, :string
  end
end
