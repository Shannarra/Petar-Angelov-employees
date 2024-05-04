require 'csv'

class FindEmployeesThatWorkedLongestJob
  include Sidekiq::Job

  def perform(*args)
    @project = CommonEmployeeProject.started.last # a bit of Rails enum niceness
    return if @project.nil?

    @project.update(upload_state: :processing)

    begin
      headers = %i[EmpID ProjectID DateFrom DateTo]
      @content = CSV.parse(@project.file.read, headers: headers)

      grouped = projectwise_group_employees!

      combined = match_employees_on_overlap!(grouped)

      sanitize_and_save_combined_data!(combined)
    rescue StandardError => e
      @project.update(upload_state: :errorneous)
    end
  end

  private

  # Groups the employees on the project
  # they have worked on.
  def projectwise_group_employees!
    @content[1..].each_with_object({}) do |line, grouped|
      start_date = Date.parse(line[:DateFrom])
      end_date = line[:DateTo] == "NULL" ? Date.today : Date.parse(line[:DateTo])

      proj_id = line[:ProjectID]
      grouped[proj_id] ||= []

      grouped[proj_id] << {
        employee: line[:EmpID],
        start_date: start_date,
        end_date: end_date,
      }
    end
  end

  def match_employees_on_overlap!(grouped)
    grouped.each_with_object({}) do |(project, project_values), overlap_table|
      project_values.each do |employee_a|
        project_values.each do |employee_b|
          # 1. Skip duplicates
          next if employee_a[:employee] == employee_b[:employee]

          employee_a_tenure = employee_a[:start_date]..employee_a[:end_date]
          employee_b_tenure = employee_b[:start_date]..employee_b[:end_date]

          # 2. If tenure does not overlap, no need to do anything, skip
          next unless (employee_a_tenure).overlaps?(employee_b_tenure)

          # 3. There is some overlap, prepare the table if needed
          overlap = tenure_overlap(employee_a_tenure, employee_b_tenure)
          uniq_key = "#{employee_a[:employee]}+#{employee_b[:employee]}";

          overlap_table[uniq_key] ||= {
            employee_a: employee_a[:employee],
            employee_b: employee_b[:employee],
            sum: 0,
            details: []
          }

          # 4. Convert the overlap to days and store it
          overlap_as_days = (overlap.max.to_date - overlap.min.to_date).to_i
          overlap_table[uniq_key][:details] << {
            project: project,
            days: overlap_as_days
          }
          overlap_table[uniq_key][:sum] += overlap_as_days

        end
      end
    end
  end

  def sanitize_and_save_combined_data!(combined)
    # sort the combined information, get only the values
    # and serialize them to JSON
    serialized = combined
                   .sort
                   .to_h
                   .values
                   .to_json

    # Then update the upload page one final time
    @project.update(upload_state: :uploaded, projects_info: serialized)
  end

  # Get the overlap between two Date ranges, if any
  def tenure_overlap(first, second)
    return nil if (first.max < second.begin or second.max < first.begin)
    [first.begin, second.begin].max..[first.max, second.max].min
  end
end
