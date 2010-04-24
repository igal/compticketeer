require 'spec_helper'

describe Batch do
  it "should create a new instance given valid attributes" do
    kind = Factory(:ticket_kind)
    attributes = Factory.attributes_for(:batch, :ticket_kind => kind)
    Batch.create!(attributes)
  end
end
