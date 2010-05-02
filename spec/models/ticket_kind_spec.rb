# == Schema Information
# Schema version: 20100502225937
#
# Table name: ticket_kinds
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  prefix     :string(255)
#  template   :text
#  created_at :datetime
#  updated_at :datetime
#  subject    :string(255)
#

require 'spec_helper'

describe TicketKind do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :prefix => "value for prefix",
      :template => "value for template"
    }
  end

  it "should create a new instance given valid attributes" do
    TicketKind.create!(@valid_attributes)
  end

  it "should set the prefix correctly" do
    Factory(:ticket_kind, :title => 'Volunteer').prefix.should == 'volunteer'
  end

  it "should not set prefix if no title is set" do
    kind = Factory.build(:ticket_kind, :title => nil, :prefix => nil)
    kind.should_not_receive(:prefix=)
    kind.set_prefix
  end
end
