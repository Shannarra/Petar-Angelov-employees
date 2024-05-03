require 'rails_helper'

RSpec.describe "common_employee_projects/edit", type: :view do
  let(:common_employee_project) {
    CommonEmployeeProject.create!(
      file: "MyString",
      upload_state: 1
    )
  }

  before(:each) do
    assign(:common_employee_project, common_employee_project)
  end

end
