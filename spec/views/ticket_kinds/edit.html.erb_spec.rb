require 'spec_helper'

describe "/ticket_kinds/edit.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assigns[:ticket_kind] = @ticket_kind = stub_model(TicketKind,
      :new_record? => false,
      :title => "value for title",
      :prefix => "value for prefix",
      :template => "value for template"
    )
  end

  it "renders the edit ticket_kind form" do
    render

    response.should have_tag("form[action=#{ticket_kind_path(@ticket_kind)}][method=post]") do
      with_tag('input#ticket_kind_title[name=?]', "ticket_kind[title]")
      with_tag('input#ticket_kind_prefix[name=?]', "ticket_kind[prefix]")
      with_tag('textarea#ticket_kind_template[name=?]', "ticket_kind[template]")
    end
  end
end
