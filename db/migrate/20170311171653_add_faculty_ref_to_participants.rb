class AddFacultyRefToParticipants < ActiveRecord::Migration[5.0]
  def change
    # facultyカラムをparticipantから削除してfacultyへの外部キーを追加
    remove_column :participants, :faculty
    add_reference :participants, :faculty, foreign_key: true
  end
end
