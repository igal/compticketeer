require 'spec_helper'

describe "/batches/index.html.erb" do
  include BatchesHelper

  before(:each) do
    assigns[:batches] = [
      stub_model(Batch),
      stub_model(Batch)
    ]
  end

  it "renders a list of batches" do
    render
  end
end
