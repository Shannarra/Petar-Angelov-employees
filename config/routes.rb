# frozen_string_literal: true

Rails.application.routes.draw do
  resources :common_employee_projects

  root 'common_employee_projects#index'
end
