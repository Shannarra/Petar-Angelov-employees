FactoryBot.define do
  factory :common_employee_project do
    file { "MyString" }
    upload_state { :processing }
  end
end
