require 'rails_helper'

RSpec.describe "common_employee_projects/index", type: :view do
  include RSpecHtmlMatchers

  let(:common_employee_projects){
    [
      CommonEmployeeProject.create!(
        file: "File",
        upload_state: 2
      ),
      CommonEmployeeProject.create!(
        file: "File",
        upload_state: 2
      )
    ]}

  before(:each) do
    assign(:common_employee_projects, common_employee_projects)

    render
  end

  context 'renders and' do
    it 'displays the basic info' do
      expect(rendered).to have_selector('h1', text: 'Common employee projects')
      expect(rendered).to have_link 'New common employee project', class: 'col-12 btn btn-success text-center'
    end

    describe 'displays a table' do
      it 'with correct layout' do
        expect(rendered).to have_table
      end
    end
  end
end
