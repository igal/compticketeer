require 'spec_helper'

describe "/tickets/show.html.erb" do
  include TicketsHelper
  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket,
      :ticket_kind_id => 1,
      :batch_id => 1,
      :email => "value for email",
      :processed => false,
      :error => "value for error"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/false/)
    response.should have_text(/value\ for\ error/)
  end
end
