require 'spec_helper'

describe "/tickets/show.html.erb" do
  include TicketsHelper
  before(:each) do
    assigns[:ticket] = @ticket = Factory(:ticket)
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/#{@ticket.email}/)
    response.should have_text(/#{@ticket.report}/)
  end
end
