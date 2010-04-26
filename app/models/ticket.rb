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

  def register_eventbrite_code
    url = URI.parse('http://www.eventbrite.com/json/discount_new')
    req = Net::HTTP::Post.new(url.path)

    eventbrite_data = SECRETS.eventbrite_data
    eventbrite_data << {
        code => self.discount_code,
    }
    req.set_form_data(eventbrite_data, '&')
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
    else
      res.error!
    end

  end
end
