class CommonEmployeeProject < ApplicationRecord
  mount_uploader :file, CommonEmployeeProjectUploader

  enum upload_state: {
    uploaded: 2,
    processing: 1,
    started: 0,
  }

  validates :upload_state, inclusion: { in: :upload_state }

  after_save :start_parsing

  private
  def start_parsing
    FindEmployeesThatWorkedLongestJob.new.perform
  end
end
