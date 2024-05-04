class CommonEmployeeProject < ApplicationRecord
  mount_uploader :file, CommonEmployeeProjectUploader

  enum upload_state: {
    errorneous: 4,
    uploaded: 3,
    processing: 2,
    started: 0,
  }

  validates :upload_state, inclusion: { in: :upload_state }

  after_save :perform_upload

  private

  # Force-runs the upload on save.
  # Usually this will be done via a rake task (see lib/tasks/)
  # but this job is so fast that most of the time it will be done by the
  # time the redirect is complete, which is nice :)
  def perform_upload
    FindEmployeesThatWorkedLongestJob.new.perform
  end
end
