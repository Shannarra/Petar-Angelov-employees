namespace :upload_files do
  task run: :environment do
    projects = CommonEmployeeProject.started

    exit(0) if projects.count.zero?

    projects.each do |project|
      FindEmployeesThatWorkedLongestJob.new.perform_async
    end
  end
end
