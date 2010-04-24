require 'spec_helper'

describe Batch do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Batch.create!(@valid_attributes)
  end
end
