require 'spec_helper'

describe TicketKindsController do

  before :each do
    login_as_admin
  end

  def create_record
    @record = Factory(:ticket_kind)
  end

  def create_records
    @records = [
      Factory(:ticket_kind),
      Factory(:ticket_kind),
    ]
  end

  describe "index" do
    it "should list ticket kinds" do
      TicketKind.destroy_all
      create_records
      get :index
      response.should be_success
      flash[:error].should be_blank
      assigns[:ticket_kinds].should == @records
    end

    it "should list empty set" do
      get :index
      response.should be_success
      flash[:error].should be_blank
      assigns[:ticket_kinds].should == []
    end
  end

  describe "new" do
    it "should display form" do
      get :new
      response.should be_success
      flash[:error].should be_blank
    end
  end

  describe "create" do
    it "should succeed when given valid attributes" do
      attributes = Factory.attributes_for(:ticket_kind)
      post :create, :ticket_kind => attributes
      response.should redirect_to(ticket_kind_path(assigns[:ticket_kind]))
      assigns[:ticket_kind].should be_valid
    end

    it "should fail when given invalid attributes" do
      attributes = Factory.attributes_for(:ticket_kind, :title => nil)
      post :create, :ticket_kind => attributes
      response.should be_success
      assigns[:ticket_kind].should_not be_valid
    end
  end

  describe "show" do
    it "should succeed" do
      create_record
      get :show, :id => @record.id
      response.should be_success
      assigns[:ticket_kind].should == @record
    end
  end

  describe "edit" do
    it "should succeed" do
      create_record
      get :edit, :id => @record.id
      response.should be_success
      assigns[:ticket_kind].should == @record
    end
  end

  describe "update" do
    it "should succeed with valid attributes" do
      create_record
      put :update, :id => @record.id, :ticket_kind => @record.attributes
      response.should redirect_to(ticket_kind_path(@record))
      assigns[:ticket_kind].should == @record
    end

    it "should fail with invalid attributes" do
      record = Factory.stub(:ticket_kind, :title => nil, :id => 123)
      TicketKind.should_receive(:find).with(record.id.to_s).and_return(record)
      put :update, :id => record.id.to_s, :ticket_kind => record.attributes
      response.should be_success
      assigns[:ticket_kind].should == record
    end
  end

  describe "destroy" do
    it "should succeed" do
      create_record
      delete :destroy, :id => @record.id
      response.should redirect_to(ticket_kinds_path)
      TicketKind.exists?(@record.id).should be_false
    end
  end

end
