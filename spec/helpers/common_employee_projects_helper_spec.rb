require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CommonEmployeeProjectsHelper. For example:
#
# describe CommonEmployeeProjectsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CommonEmployeeProjectsHelper, type: :helper do
  let(:processing_project) {
    build(:common_employee_project,
          upload_state: :processing,
          file: '/dev/folder/asd.txt'
         )
  }

  let(:successful_project) {
    build(:common_employee_project, upload_state: :uploaded)
  }

  let(:errorneous_project) {
    build(:common_employee_project, upload_state: :errorneous)
  }

  context 'all helpers work correctly' do
    describe 'upload_verb' do
      it 'returns correct value for started' do
        expect(helper.upload_verb(processing_project)).to eq 'state'
      end
      it 'returns correct value for finished' do
        expect(helper.upload_verb(successful_project)).to eq 'result'
        expect(helper.upload_verb(errorneous_project)).to eq 'result'
      end
    end

    describe 'project_file_name' do
      it 'returns correct basename when no file is stored correctly' do
        expect(helper.project_file_name(processing_project)).to eq '[Filename retrieval error]'
      end
    end

    describe 'text_color_from_state' do
      it 'returns correct color for both states' do
        expect(helper.text_color_from_state('uploaded')).to eq 'text-success'
        expect(helper.text_color_from_state('errorneous')).to eq 'text-danger'
      end
    end
  end
end
