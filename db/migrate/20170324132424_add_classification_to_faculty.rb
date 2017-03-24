class AddClassificationToFaculty < ActiveRecord::Migration[5.0]
  def change
    add_column :faculties, :classification, :integer
  end
end
