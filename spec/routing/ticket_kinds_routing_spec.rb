require 'spec_helper'

describe TicketKindsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/ticket_kinds" }.should route_to(:controller => "ticket_kinds", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/ticket_kinds/new" }.should route_to(:controller => "ticket_kinds", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/ticket_kinds/1" }.should route_to(:controller => "ticket_kinds", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/ticket_kinds/1/edit" }.should route_to(:controller => "ticket_kinds", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/ticket_kinds" }.should route_to(:controller => "ticket_kinds", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/ticket_kinds/1" }.should route_to(:controller => "ticket_kinds", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/ticket_kinds/1" }.should route_to(:controller => "ticket_kinds", :action => "destroy", :id => "1") 
    end
  end
end
