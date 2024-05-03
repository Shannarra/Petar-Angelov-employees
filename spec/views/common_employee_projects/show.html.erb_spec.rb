require 'rails_helper'

RSpec.describe "common_employee_projects/show", type: :view do
  before(:each) do
    assign(:common_employee_project, CommonEmployeeProject.create!(
      file: "File",
      upload_state: 2
    ))
  end

end
