module CommonEmployeeProjectsHelper
  def upload_verb(project)
    %w[started processing]
      .include?(project.upload_state) ? 'state' : 'result'
  end

  def project_file_name(project)
    return '[Filename retrieval error]' unless project.file.file

    File.basename(project.file&.file&.file)
  end

  def text_color_from_state(state)
    "text-#{state == 'errorneous' ? 'danger' : 'success'}"
  end

  def sorted_projects_info(project)
    JSON
      .parse(project&.projects_info || '{}')
      .sort {|x, y| y['sum'] - x['sum'] }
  end
end
