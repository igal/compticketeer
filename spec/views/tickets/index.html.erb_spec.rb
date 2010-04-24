require 'spec_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:tickets] = [
      stub_model(Ticket,
        :ticket_kind_id => 1,
        :batch_id => 1,
        :email => "value for email",
        :processed => false,
        :error => "value for error"
      ),
      stub_model(Ticket,
        :ticket_kind_id => 1,
        :batch_id => 1,
        :email => "value for email",
        :processed => false,
        :error => "value for error"
      )
    ]
  end

  it "renders a list of tickets" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", "value for error".to_s, 2)
  end
end
