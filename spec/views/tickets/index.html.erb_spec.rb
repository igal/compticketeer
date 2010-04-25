require 'spec_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:tickets] = [
      Factory.stub(:ticket, :email => "value for email", :error => "value for error"),
    ]
  end

  it "renders a list of tickets" do
    render
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", "value for error".to_s, 2)
  end
end
