require 'spec_helper'

describe Batch do
  it "should create a new instance given valid attributes" do
    kind = Factory(:ticket_kind)
    attributes = Factory.attributes_for(:batch, :ticket_kind => kind)

    Batch.create!(attributes)
  end

  it "should create associated tickets" do
    batch = Factory(:batch, :emails => "foo@bar.com\nbaz@qux.org")

    batch.tickets.size.should == 2
    batch.tickets.map(&:email).should include("foo@bar.com")
    batch.tickets.map(&:email).should include("baz@qux.org")
  end

  it "should not create record and report error if emails are invalid" do
    batch = Factory.build(:batch, :emails => "foo@bar.com\nomgwtfbbq\n\r\n")

    batch.should_not be_valid

    batch.errors.size.should == 1
    batch.errors.full_messages.first.should =~ /omgwtfbbq/
  end
end
