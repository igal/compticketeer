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
    it "should get its ticket_kind from the batch it's created in" do
      kind = Factory(:ticket_kind, :title => 'Volunteer')
      batch = Factory(:batch, :ticket_kind => kind)
      Factory(:ticket, :batch => batch).ticket_kind.title.should == 'Volunteer'
    end
  end

  describe "discount_code" do
    it "should have a generated discount code" do
      kind = Factory(:ticket_kind, :title => 'Speaker')
      batch = Factory(:batch, :ticket_kind => kind)
      Factory(:ticket, :email => "foo@bar.com", :batch => batch).discount_code.should == "speaker_foobarcom"
    end
  end
end
