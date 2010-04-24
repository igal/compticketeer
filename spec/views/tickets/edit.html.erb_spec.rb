require 'spec_helper'

describe "/tickets/edit.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:ticket] = @ticket = stub_model(Ticket,
      :new_record? => false,
      :ticket_kind_id => 1,
      :batch_id => 1,
      :email => "value for email",
      :processed => false,
      :error => "value for error"
    )
  end

  it "renders the edit ticket form" do
    render

    response.should have_tag("form[action=#{ticket_path(@ticket)}][method=post]") do
      with_tag('input#ticket_ticket_kind_id[name=?]', "ticket[ticket_kind_id]")
      with_tag('input#ticket_batch_id[name=?]', "ticket[batch_id]")
      with_tag('input#ticket_email[name=?]', "ticket[email]")
      with_tag('input#ticket_processed[name=?]', "ticket[processed]")
      with_tag('input#ticket_error[name=?]', "ticket[error]")
    end
  end
end
