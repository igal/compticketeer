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

  describe "process" do
    it "should register EventBrite code, send email and set processed flag" do
      ticket = Factory(:ticket)
      ticket.should_receive(:register_code)
      ticket.should_receive(:send_email)
      ticket.should_receive(:processed=).with(true)
      ticket.should_receive(:save!)
      ticket.process.should == :sent
    end
  end

  describe "register_code" do
    it "should not register during tests unless overridden" do
      ticket = Factory(:ticket)
      Net::HTTP.should_not_receive(:post_form)

      Ticket.disable_register_code.should be_true
      ticket.register_code.should be_false
    end

    it "should register" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => {"process"=>{"id"=>268329, "message"=>"discount_new : Complete ", "status"=>"OK"}}.to_json)
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_true
      ticket.error.should be_nil
    end

    it "should fail if EventBrite responds with an API error" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => {"error"=>{"error_message"=>"Please Please enter a valid discount code.", "error_type"=>"Discount error"}}.to_json)
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.error.should =~ /valid discount code/
    end

    it "should fail if EventBrite responds with invalid JSON" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => 'invalid/json')
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.error.should =~ /JSON/
    end

    it "should fail if EventBrite rejects request" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPForbidden.new('1.1', '401', 'Go away!')
      res.stub!(:body => 'Get off my lawn!')
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.error.should =~ /401.+Get off my lawn/
    end

    it "should fail if SECRETS haven't been configured" do
      Ticket.stub!(:disable_register_code => false)
      stub_invalid_eventbrite_secrets

      Net::HTTP.should_not_receive(:post_form)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.error.should =~ /.+secrets\.yml.+/
    end

    # TODO test remaining paths
  end
end
