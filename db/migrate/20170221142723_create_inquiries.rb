class CreateInquiries < ActiveRecord::Migration[5.0]
  def change
    create_table :inquiries do |t|
      t.string :subject
      t.text :body
      t.boolean :unread, default: true
      t.integer :participant_id
      t.integer :experiment_id

      t.timestamps
    end
    add_index :inquiries, :participant_id
    add_index :inquiries, :experiment_id
  end
end
