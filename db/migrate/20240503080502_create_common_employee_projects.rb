class CreateCommonEmployeeProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :common_employee_projects do |t|
      t.string :file
      t.integer :upload_state, default: 0

      t.timestamps
    end
  end
end
