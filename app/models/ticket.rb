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

  private

  def set_ticket_kind
    self.ticket_kind = self.batch.ticket_kind
  end

  def generate_discount_code
    self.discount_code = self.ticket_kind ? self.ticket_kind.prefix : ''  # check ticket_kind existence because this method is called before_validation
    self.discount_code += '_' + self.email.gsub(/\W/, '')
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
