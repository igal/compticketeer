# == Schema Information
# Schema version: 20100502225937
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

class Ticket < ActiveRecord::Base
  # Associations
  belongs_to :batch
  belongs_to :ticket_kind

  # Scopes
  named_scope :ordered, :order => 'created_at desc'

  # Validations
  validates_presence_of :batch
  validates_presence_of :ticket_kind
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  # Callbacks
  before_validation :set_ticket_kind
  before_validation :generate_discount_code

  # Disable the registration of codes during tests?
  cattr_accessor :disable_register_code

  # Acts As State Machine
  include AASM
  aasm_column :status
  aasm_initial_state :created
  aasm_state :created
  aasm_state :registering_code
  aasm_state :registered_code
  aasm_state :failed_to_register_code
  aasm_state :sending_email
  aasm_state :sent_email
  aasm_state :failed_to_send_email
  aasm_event(:registering_code)        { transitions :to => :registering_code,        :from => :created }
  aasm_event(:registered_code)         { transitions :to => :registered_code,         :from => :registering_code }
  aasm_event(:failed_to_register_code) { transitions :to => :failed_to_register_code, :from => :registering_code }
  aasm_event(:sending_email)           { transitions :to => :sending_email,           :from => :registered_code }
  aasm_event(:sent_email)              { transitions :to => :sent_email,              :from => :sending_email }
  aasm_event(:failed_to_send_email)    { transitions :to => :failed_to_send_email,    :from => :sending_email }

  # Return human-readable label for status.
  def status_label
    label = self.status.to_s.gsub('created', 'working').gsub(/_/, ' ').capitalize
    label << '...' unless self.done?
    label << '!' if self.success? == false
    return label
  end

  # Is the ticket processing done, be it success or failure?
  def done?
    return [:failed_to_register_code, :failed_to_send_email, :sent_email].include?(self.status.try(:to_sym))
  end

  # Was the ticket processed successfully? True if yes, false if failed, nil if not finished.
  def success?
    return self.done? ?
      self.status.to_sym == :sent_email :
      nil
  end

  # Set this ticket's kind if needed and one's available in the batch.
  def set_ticket_kind
    if self.ticket_kind.nil? && self.batch && self.batch.ticket_kind
      self.ticket_kind = self.batch.ticket_kind
    end
  end

  # Generate a discount code for this ticket.
  def generate_discount_code
    if self.discount_code.nil? && self.email.present?
      # Add a prefix to the ticket if possible
      s = self.ticket_kind ? (self.ticket_kind.prefix + '_') : ''
      # Generate a discount code based on the user's email
      salted_email = "#{self.email} #{SECRETS.discount_code_salt}"
      email_hash = Digest::MD5.hexdigest(salted_email)[0..6]
      email_fragment = self.email.gsub(/\W/, '')
      s << "#{email_fragment}_#{email_hash}"
      self.discount_code = s
    end
  end

  # Process this ticket and return the status.
  def process
    self.register_code
    self.send_email
    return self.status
  end

  # Register the discount code with EventBrite.
  def register_code
    self.registering_code!
    if self.class.disable_register_code
      self.registered_code!
      return false
    else
      if SECRETS.eventbrite_data['app_key'] == 'test'
        self.update_attribute :report, "Couldn't register EventBrite code because no API key was defined in 'config/secrets.yml'"
        self.failed_to_register_code!
        return false
      end

      query = {
        'code' => self.discount_code,
        'percent_off' => '100',
        'quantity_available' => '1',
      }
      for key in %w[app_key user_key event_id tickets]
        query[key] = SECRETS.eventbrite_data[key]
      end

      # TODO refactor this to shorten the code, eliminate redundancy, etc
      res = Net::HTTP.post_form(URI.parse('http://www.eventbrite.com/json/discount_new'), query)
      case res
      when Net::HTTPOK
        begin
          answer = JSON.parse(res.body)
          if answer['error']
            if answer['error'].try(:[], 'error_message').to_s =~ /already in use/
              # Ticket exists succeeded
              self.update_attribute :report, "EventBrite code already exists: #{res.body}"
              self.registered_code!
              return true
            else
              # Has error of some other kind
              self.update_attribute :report, "Could not register EventBrite code: #{res.body}"
              self.failed_to_register_code!
              return false
            end
          else
            # Registration succeeded
            self.update_attribute :report, "Registered EventBrite code: #{res.body}"
            self.registered_code!
            return true
          end
        rescue JSON::ParserError => e
          self.update_attribute :report, "Could not parse EventBrite JSON response: #{res.body}"
          self.failed_to_register_code!
          return false
        end
      else
        self.update_attribute :report, "Could not register EventBrite code, got HTTP status #{res.code}: #{res.body}"
        self.failed_to_register_code!
        return false
      end
    end
  end

  # Send email for this ticket.
  def send_email
    self.sending_email!
    begin
      Notifier.deliver_ticket(self)
    rescue Exception => e
      # TODO catch specific exception?
      self.update_attribute :report, "Could not send email: #{e.class.name}, #{e.message}"
      self.failed_to_send_email!
    else
      self.sent_email!
    end
  end

  # Return a filled-in template for email.
  def fill_email_template
    return self.ticket_kind.template.gsub(/%CODE%/i, self.discount_code)
  end
end
