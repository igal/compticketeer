require 'spec_helper'

describe "/batches/new.html.erb" do
  include BatchesHelper

  before(:each) do
    assigns[:batch] = stub_model(Batch,
      :new_record? => true
    )
  end

  it "renders new batch form" do
    render

    response.should have_tag("form[action=?][method=post]", batches_path) do
    end
  end
end
