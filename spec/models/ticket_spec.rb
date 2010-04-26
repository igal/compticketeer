require 'spec_helper'

describe Ticket do
  it "should create a new instance given valid attributes" do
    Factory(:ticket)
  end

  describe "status" do
    it "should have :pending status intially" do
      Factory(:ticket, :processed => nil, :error => nil).status.should == :pending
    end

    it "should have :sent status if processed and has no error" do
      Factory(:ticket, :processed => true, :error => nil).status.should == :sent
    end

    it "should have :failed status if processed and has an error" do
      Factory(:ticket, :processed => true, :error => "omg").status.should == :failed
    end
  end

  describe "ticket_kind" do
    it "should assign ticket_kind from the assigned batch" do
      kind = Factory(:ticket_kind)
      batch = Factory(:batch, :ticket_kind => kind)
      Factory(:ticket, :batch => batch).ticket_kind.should == kind
    end

    it "should not reset ticket_kind if already set" do
      kind = Factory.build(:ticket_kind)
      ticket = Factory.build(:ticket, :ticket_kind => kind)
      ticket.should_not_receive(:ticket_kind=)
      ticket.save!
    end
  end

  describe "discount_code" do
    it "should be generated" do
      kind = Factory(:ticket_kind, :title => 'Speaker')
      batch = Factory(:batch, :ticket_kind => kind)
      Factory(:ticket, :email => "foo@bar.com", :batch => batch).discount_code.should == "speaker_foobarcom"
    end

    it "should not be generated if already set" do
      ticket = Factory(:ticket)
      ticket.should_not_receive(:discount_code=)
      ticket.generate_discount_code
    end

    it "should not be generated if no email set" do
      ticket = Factory.build(:ticket, :email => nil)
      ticket.should_not_receive(:discount_code=)
      ticket.generate_discount_code
    end
  end
end
