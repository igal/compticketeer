# == Schema Information
# Schema version: 20100426102827
#
# Table name: tickets
#
#  id             :integer         not null, primary key
#  ticket_kind_id :integer
#  batch_id       :integer
#  email          :string(255)
#  report         :text(2048)
#  processed_at   :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  discount_code  :string(255)
#  status         :string(255)
#

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

  describe "status_label" do
    it "should have a status label" do
      Factory(:ticket).status_label.should_not be_blank
    end

    it "should be capitalized" do
      ticket = Factory(:ticket)

      ticket.status_label.should == ticket.status_label.capitalize
    end

    it "should be able to emit spaces" do
      Factory(:ticket, :status => :sending_email).status_label.should =~ /\s/
    end

    it "should put '...' at end of unfinished status" do
      Factory(:ticket, :status => :sending_email).status_label.should =~ /\.\.\.$/
    end

    it "should put '!' at end of error" do
      Factory(:ticket, :status => :failed_to_send_email).status_label.should =~ /!$/
    end
  end

  describe "done?" do
    it "should be true for successfully finished work" do
      Factory(:ticket, :status => :sent_email).done?.should be_true
    end

    it "should be true for failed finished work" do
      Factory(:ticket, :status => :failed_to_send_email).done?.should be_true
    end
    
    it "should be false for unfinished work" do
      Factory(:ticket, :status => :sending_email).done?.should be_false
    end
  end

  describe "success?" do
    it "should be true if successfully completed" do
      Factory(:ticket, :status => :sent_email).success?.should be_true
    end

    it "should be false if ended in failure" do
      Factory(:ticket, :status => :failed_to_send_email).success?.should be_false
    end

    it "should be nil if not done" do
      Factory(:ticket, :status => :sending_email).success?.should be_nil
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

    it "should succeed if discount code already exists" do
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
  end
end
