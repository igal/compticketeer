require 'spec_helper'

describe "/ticket_kinds/index.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assigns[:ticket_kinds] = [
      stub_model(TicketKind,
        :title => "value for title",
        :prefix => "value for prefix",
        :template => "value for template"
      ),
      stub_model(TicketKind,
        :title => "value for title",
        :prefix => "value for prefix",
        :template => "value for template"
      )
    ]
  end

  it "renders a list of ticket_kinds" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for prefix".to_s, 2)
    response.should have_tag("tr>td", "value for template".to_s, 2)
  end
end
