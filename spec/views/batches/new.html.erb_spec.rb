require 'spec_helper'

describe "/batches/new.html.erb" do
  include BatchesHelper

  before(:each) do
    assigns[:batch] = Factory.build(:batch, :ticket_kind => nil)
    assigns[:ticket_kinds] = [Factory.stub :ticket_kind]
  end

  it "renders new batch form" do
    render

    response.should have_tag("form[action=?][method=post]", batches_path) do
    end
  end
end
