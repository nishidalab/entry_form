class AddRequirementToExperiments < ActiveRecord::Migration[5.0]
  def change
    add_column :experiments, :requirement, :text
  end
end
