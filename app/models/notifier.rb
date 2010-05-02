class Notifier < ActionMailer::Base

  def self.configured?
    hostname = SECRETS.try(:notifier).try(:[], 'address')
    return(hostname.present? && hostname != 'test')
  end

  def ticket(ticket, sent_at = Time.now)
    unless self.class.configured?
      raise ArgumentError, "Email settings for 'notifier' must be set in 'config/secrets.yml'"
    end

    subject    'Notifier#ticket'
    recipients ticket.email
    from       SECRETS.notifier['user_name']
    sent_on    sent_at

    body       :contents => ticket.fill_email_template
  end

end
