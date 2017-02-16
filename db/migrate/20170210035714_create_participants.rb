class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :yomi
      t.integer :gender
      t.date :birth
      t.integer :classification
      t.integer :grade
      t.integer :faculty
      t.text :address

      t.timestamps
    end
  end
end
