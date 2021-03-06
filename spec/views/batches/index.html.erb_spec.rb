require 'spec_helper'

describe "/batches/index.html.erb" do
  include BatchesHelper

  before(:each) do
    assigns[:batches] = [
      Factory.stub(:batch),
      Factory.stub(:batch),
    ]
  end

  it "renders a list of batches" do
    render
  end
end
