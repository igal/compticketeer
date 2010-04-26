require 'spec_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:tickets] = [
      Factory(:ticket, :email => "foo@bar.com", :error => "value for error"),
    ]
  end

  it "renders a list of tickets" do
    render
    response.should have_tag("tr>td", "foo@bar.com".to_s, 2)
    response.should have_tag("tr>td", "value for error".to_s, 2)
  end
end
