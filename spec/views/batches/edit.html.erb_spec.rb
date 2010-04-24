require 'spec_helper'

describe "/batches/edit.html.erb" do
  include BatchesHelper

  before(:each) do
    assigns[:batch] = @batch = stub_model(Batch,
      :new_record? => false
    )
  end

  it "renders the edit batch form" do
    render

    response.should have_tag("form[action=#{batch_path(@batch)}][method=post]") do
    end
  end
end
