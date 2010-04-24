require 'spec_helper'

describe "/ticket_kinds/show.html.erb" do
  include TicketKindsHelper
  before(:each) do
    assigns[:ticket_kind] = @ticket_kind = stub_model(TicketKind,
      :title => "value for title",
      :prefix => "value for prefix",
      :template => "value for template"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ prefix/)
    response.should have_text(/value\ for\ template/)
  end
end
