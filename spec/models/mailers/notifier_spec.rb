require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Notifier do
  CHARSET = 'utf-8'

  fixtures :users

  include ActionMailer::Quoting

  before :each do
    @ticket = Factory :ticket

    @email = TMail::Mail.new
    @email.set_content_type 'text', 'plain', { 'charset' => CHARSET }
    @email.mime_version = '1.0'
  end

  it "should not send ticket if notifier is not configured" do
    Notifier.stub!(:configured? => false)

    lambda { Notifier.deliver_ticket(@ticket) }.should raise_error(ArgumentError)
  end

  it "should send ticket with a code if notifier is configured" do
    stub_notifier_secrets

    lambda { Notifier.deliver_ticket(@ticket) }.should change(ActionMailer::Base.deliveries, :size).by(1)

    body = ActionMailer::Base.deliveries.last.body
    body.should =~ /#{@ticket.discount_code}/
  end
end