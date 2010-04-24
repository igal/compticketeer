require 'spec_helper'

describe Ticket do
  before(:each) do
    @valid_attributes = {
      :ticket_kind_id => 1,
      :batch_id => 1,
      :email => "value for email",
      :processed => false,
      :error => "value for error",
      :processed_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Ticket.create!(@valid_attributes)
  end
end
