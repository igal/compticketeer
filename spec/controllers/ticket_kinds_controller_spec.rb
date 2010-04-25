require 'spec_helper'

describe TicketKindsController do

  before :each do
    login_as_admin
  end

  def mock_ticket_kind(stubs={})
    @mock_ticket_kind ||= mock_model(TicketKind, stubs)
  end

  describe "GET index" do
    it "assigns all ticket_kinds as @ticket_kinds" do
      TicketKind.stub(:find).with(:all).and_return([mock_ticket_kind])
      get :index
      assigns[:ticket_kinds].should == [mock_ticket_kind]
    end
  end

  describe "GET show" do
    it "assigns the requested ticket_kind as @ticket_kind" do
      TicketKind.stub(:find).with("37").and_return(mock_ticket_kind)
      get :show, :id => "37"
      assigns[:ticket_kind].should equal(mock_ticket_kind)
    end
  end

  describe "GET new" do
    it "assigns a new ticket_kind as @ticket_kind" do
      TicketKind.stub(:new).and_return(mock_ticket_kind)
      get :new
      assigns[:ticket_kind].should equal(mock_ticket_kind)
    end
  end

  describe "GET edit" do
    it "assigns the requested ticket_kind as @ticket_kind" do
      TicketKind.stub(:find).with("37").and_return(mock_ticket_kind)
      get :edit, :id => "37"
      assigns[:ticket_kind].should equal(mock_ticket_kind)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created ticket_kind as @ticket_kind" do
        TicketKind.stub(:new).with({'these' => 'params'}).and_return(mock_ticket_kind(:save => true))
        post :create, :ticket_kind => {:these => 'params'}
        assigns[:ticket_kind].should equal(mock_ticket_kind)
      end

      it "redirects to the created ticket_kind" do
        TicketKind.stub(:new).and_return(mock_ticket_kind(:save => true))
        post :create, :ticket_kind => {}
        response.should redirect_to(ticket_kind_url(mock_ticket_kind))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ticket_kind as @ticket_kind" do
        TicketKind.stub(:new).with({'these' => 'params'}).and_return(mock_ticket_kind(:save => false))
        post :create, :ticket_kind => {:these => 'params'}
        assigns[:ticket_kind].should equal(mock_ticket_kind)
      end

      it "re-renders the 'new' template" do
        TicketKind.stub(:new).and_return(mock_ticket_kind(:save => false))
        post :create, :ticket_kind => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested ticket_kind" do
        TicketKind.should_receive(:find).with("37").and_return(mock_ticket_kind)
        mock_ticket_kind.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ticket_kind => {:these => 'params'}
      end

      it "assigns the requested ticket_kind as @ticket_kind" do
        TicketKind.stub(:find).and_return(mock_ticket_kind(:update_attributes => true))
        put :update, :id => "1"
        assigns[:ticket_kind].should equal(mock_ticket_kind)
      end

      it "redirects to the ticket_kind" do
        TicketKind.stub(:find).and_return(mock_ticket_kind(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(ticket_kind_url(mock_ticket_kind))
      end
    end

    describe "with invalid params" do
      it "updates the requested ticket_kind" do
        TicketKind.should_receive(:find).with("37").and_return(mock_ticket_kind)
        mock_ticket_kind.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :ticket_kind => {:these => 'params'}
      end

      it "assigns the ticket_kind as @ticket_kind" do
        TicketKind.stub(:find).and_return(mock_ticket_kind(:update_attributes => false))
        put :update, :id => "1"
        assigns[:ticket_kind].should equal(mock_ticket_kind)
      end

      it "re-renders the 'edit' template" do
        TicketKind.stub(:find).and_return(mock_ticket_kind(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested ticket_kind" do
      TicketKind.should_receive(:find).with("37").and_return(mock_ticket_kind)
      mock_ticket_kind.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the ticket_kinds list" do
      TicketKind.stub(:find).and_return(mock_ticket_kind(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(ticket_kinds_url)
    end
  end

end
