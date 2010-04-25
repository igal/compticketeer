require 'spec_helper'

describe Ticket do
  it "should create a new instance given valid attributes" do
    Factory(:ticket)
  end

  describe "status" do
    it "should have :pending status intially" do
      Factory.build(:ticket, :processed => nil, :error => nil).status.should == :pending
    end

    it "should have :sent status if processed and has no error" do
      Factory.build(:ticket, :processed => true, :error => nil).status.should == :sent
    end

    it "should have :failed status if processed and has an error" do
      Factory.build(:ticket, :processed => true, :error => "omg").status.should == :failed
    end
  end
end