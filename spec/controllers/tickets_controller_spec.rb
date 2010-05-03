require 'spec_helper'

describe TicketsController do

  before :each do
    login_as_admin
  end

  def mock_ticket(stubs={})
    @mock_ticket ||= mock_model(Ticket, stubs)
  end

  describe "GET index" do
    it "assigns all tickets as @tickets" do
      Ticket.stub(:find).with(:all).and_return([mock_ticket])
      get :index
      assigns[:tickets].should == [mock_ticket]
    end
  end

  describe "GET show" do
    it "assigns the requested ticket as @ticket" do
      Ticket.stub(:find).with("37").and_return(mock_ticket)
      get :show, :id => "37"
      assigns[:ticket].should equal(mock_ticket)
    end
  end

end
