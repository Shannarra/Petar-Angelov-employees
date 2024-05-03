require 'rails_helper'

RSpec.describe "common_employee_projects/index", type: :view do
  before(:each) do
    assign(:common_employee_projects, [
      CommonEmployeeProject.create!(
        file: "File",
        upload_state: 2
      ),
      CommonEmployeeProject.create!(
        file: "File",
        upload_state: 2
      )
    ])
  end

end
