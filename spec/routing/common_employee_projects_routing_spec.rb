require "rails_helper"

RSpec.describe CommonEmployeeProjectsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/common_employee_projects").to route_to("common_employee_projects#index")
    end

    it "routes to #new" do
      expect(get: "/common_employee_projects/new").to route_to("common_employee_projects#new")
    end

    it "routes to #show" do
      expect(get: "/common_employee_projects/1").to route_to("common_employee_projects#show", id: "1")
    end

    it "does NOT route to #edit" do
      expect(get: "/common_employee_projects/1/edit").not_to route_to("common_employee_projects#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/common_employee_projects").to route_to("common_employee_projects#create")
    end

    it "does NOT route to #update via PUT" do
      expect(put: "/common_employee_projects/1").not_to route_to("common_employee_projects#update", id: "1")
    end

    it "does NOT route to #update via PATCH" do
      expect(patch: "/common_employee_projects/1").not_to route_to("common_employee_projects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/common_employee_projects/1").to route_to("common_employee_projects#destroy", id: "1")
    end
  end
end
