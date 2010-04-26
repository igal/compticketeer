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

  # Disable the registration of EventBrite codes during tests?
  cattr_accessor :disable_register_eventbrite_code

  # Return the status of this ticket:
  # * :failed
  # * :sent
  # * :pending
  def status
    if self.processed
      self.error ?
        :failed :
        :sent
    else
      :pending
    end
  end

  # Process this ticket and return the status.
  def process
    self.register_eventbrite_code
    self.send_email

    self.processed = true
    self.save!
    return self.status
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
      s << self.email.gsub(/\W/, '')
      self.discount_code = s
    end
  end

  # Register the discount code with EventBrite.
  def register_eventbrite_code
    if self.class.disable_register_eventbrite_code
      return false
    else
      if SECRETS.eventbrite_data['app_key'] == 'test'
        self.error = "Couldn't register EventBrite code because no API key was defined in 'config/secrets.yml'"
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

      res = Net::HTTP.post_form(URI.parse('http://www.eventbrite.com/json/discount_new'), query)
      case res
      when Net::HTTPOK
        begin
          answer = JSON.parse(res.body)
          if answer['error']
            self.error = "Could not register EventBrite code: #{res.body}"
            return false
          else
            # SUCCESS!!1!
            return true
          end
        rescue JSON::ParserError => e
          self.error = "Could not parse EventBrite JSON response: #{res.body}"
          return false
        end
      else
        self.error = "Could not register EventBrite code, got HTTP status #{res.code}: #{res.body}"
        return false
      end
    end
  end
end
