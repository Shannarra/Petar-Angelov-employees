class CommonEmployeeProjectsController < InheritedResources::Base
  def create
    create!(notice: 'Project upload started successfully!', alert: @errors) { root_url }
  end

  private

    def common_employee_project_params
      params.require(:common_employee_project).permit(:file, :file_cache, :upload_state)
    end

end
