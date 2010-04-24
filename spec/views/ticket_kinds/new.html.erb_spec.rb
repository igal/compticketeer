require 'spec_helper'

describe "/ticket_kinds/new.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assigns[:ticket_kind] = stub_model(TicketKind,
      :new_record? => true,
      :title => "value for title",
      :prefix => "value for prefix",
      :template => "value for template"
    )
  end

  it "renders new ticket_kind form" do
    render

    response.should have_tag("form[action=?][method=post]", ticket_kinds_path) do
      with_tag("input#ticket_kind_title[name=?]", "ticket_kind[title]")
      with_tag("input#ticket_kind_prefix[name=?]", "ticket_kind[prefix]")
      with_tag("textarea#ticket_kind_template[name=?]", "ticket_kind[template]")
    end
  end
end
