class AddProjectsInfoToCommonEmployeeProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :common_employee_projects, :projects_info, :json
  end
end
