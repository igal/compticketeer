require 'spec_helper'

describe Ticket do
  it "should create a new instance given valid attributes" do
    Factory(:ticket)
  end

  describe "status" do
    it "should have 'created' status intially" do
      Factory(:ticket, :report => nil).status.should == 'created'
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
    it "should register code and send email" do
      ticket = Factory(:ticket)
      ticket.should_receive(:register_code)
      ticket.should_receive(:send_email)
      ticket.process
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
      ticket.status.should == "registered_code"
    end

    it "should update" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => {"error"=>{"error_message"=>"The discount code \"volunteer_foo\" is already in use.", "error_type"=>"Discount error"}}.to_json)
      Net::HTTP.should_receive(:post_form).and_return(res)

      ticket = Factory(:ticket)

      ticket.register_code.should be_true
      ticket.status.should == "registered_code"
      ticket.report.should =~ /already exists/
    end

    it "should fail if EventBrite responds with an API error" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => {"error"=>{"error_message"=>"Please enter a valid discount code.", "error_type"=>"Discount error"}}.to_json)
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.report.should =~ /Discount error/
      ticket.status.should == "failed_to_register_code"
    end

    it "should fail if EventBrite responds with invalid JSON" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      res.stub!(:body => 'invalid/json')
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.report.should =~ /JSON/
      ticket.status.should == "failed_to_register_code"
    end

    it "should fail if EventBrite rejects request" do
      Ticket.stub!(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPForbidden.new('1.1', '401', 'Go away!')
      res.stub!(:body => 'Get off my lawn!')
      Net::HTTP.should_receive(:post_form).and_return(res)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.report.should =~ /401.+Get off my lawn/
      ticket.status.should == "failed_to_register_code"
    end

    it "should fail if SECRETS haven't been configured" do
      Ticket.stub!(:disable_register_code => false)
      stub_invalid_eventbrite_secrets

      Net::HTTP.should_not_receive(:post_form)
      ticket = Factory(:ticket)

      ticket.register_code.should be_false
      ticket.report.should =~ /.+secrets\.yml.+/
      ticket.status.should == "failed_to_register_code"
    end

    # TODO test remaining paths
  end
end
