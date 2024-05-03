require 'rails_helper'

RSpec.describe "common_employee_projects/new", type: :view do
  before(:each) do
    assign(:common_employee_project, CommonEmployeeProject.new(
      file: "MyString",
      upload_state: 1
    ))
  end

end
