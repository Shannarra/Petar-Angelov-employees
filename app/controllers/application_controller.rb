# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def action_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end
end
