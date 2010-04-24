require 'spec_helper'

describe BatchesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/batches" }.should route_to(:controller => "batches", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/batches/new" }.should route_to(:controller => "batches", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/batches/1" }.should route_to(:controller => "batches", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/batches/1/edit" }.should route_to(:controller => "batches", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/batches" }.should route_to(:controller => "batches", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/batches/1" }.should route_to(:controller => "batches", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/batches/1" }.should route_to(:controller => "batches", :action => "destroy", :id => "1") 
    end
  end
end
