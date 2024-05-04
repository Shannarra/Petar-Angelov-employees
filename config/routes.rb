# frozen_string_literal: true

Rails.application.routes.draw do
  resources :common_employee_projects, except: %i[edit update]

  root 'common_employee_projects#index'
end
