class AddColumnMember < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :activated, :boolean
    add_column :members, :admin, :boolean
  end
end
