require 'spec_helper'

describe "/ticket_kinds/index.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assigns[:ticket_kinds] = [
      Factory(:ticket_kind, :title => "value for title", :prefix => "value for prefix", :template => "value for template"),
      Factory(:ticket_kind, :title => "value for title", :prefix => "value for prefix", :template => "value for template"),
    ]
  end

  it "renders a list of ticket_kinds" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
  end
end
