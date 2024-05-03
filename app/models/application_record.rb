# frozen_string_literal: true

# Jobs usually are to be run in a Rake Task, but for the sake of
# this app we can also run them upon saving the uploaded file
require 'sidekiq'

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
