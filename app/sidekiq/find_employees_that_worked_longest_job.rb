require 'csv'

class FindEmployeesThatWorkedLongestJob
  include Sidekiq::Job

  def perform(*args)
    @project = CommonEmployeeProject.where(upload_state: :started).last
    return if @project.nil?

    @project.update(upload_state: :processing)

    headers = %i[EmpID ProjectID DateFrom DateTo]
    @content = CSV.parse(@project.file.read, headers: headers)

    grouped = group_employees!

    combined = combine_employees!(grouped)

    sanitize_combined_data!(combined)
  end

  private

  def group_employees!
    grouped = Hash.new

    @content[1..].each do |line|
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

    grouped
  end

  def combine_employees!(grouped)
    grouped.each_with_object({}) do |(project, proj_values), combination|
      proj_values[..-1].each do |employee_a|
        proj_values[1..].each do |employee_b|
          next if employee_a[:employee] == employee_b[:employee]

          employee_a_tenure = employee_a[:start_date]..employee_a[:end_date]
          employee_b_tenure = employee_b[:start_date]..employee_b[:end_date]

          # tenure does not overlap, no need to do anything
          next unless (employee_a_tenure).overlaps?(employee_b_tenure)

          overlap = tenure_overlap(employee_a_tenure, employee_b_tenure)
          uniq_key = "#{employee_a[:employee]}_#{employee_b[:employee]}";

          combination[uniq_key] ||= {
            employee_a: employee_a[:employee],
            employee_b: employee_b[:employee],
            sum: 0,
            details: []
          }

          overlap_as_days = (overlap.max.to_date - overlap.min.to_date).to_i
          combination[uniq_key][:details] << {
            project: project,
            days: overlap_as_days
          }
          combination[uniq_key][:sum] += overlap_as_days
        end
      end
    end
  end

  def sanitize_combined_data!(combined)
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


  def tenure_overlap(first, second)
    return nil if (first.max < second.begin or second.max < first.begin)
    [first.begin, second.begin].max..[first.max, second.max].min
  end
end
