class Batch < ActiveRecord::Base
  has_many :tickets
  belongs_to :ticket_kind

  named_scope :ordered, :order => 'created_at desc'

  validates_presence_of :ticket_kind_id
  validates_presence_of :emails
 
  before_validation :create_tickets
  after_validation :validate_tickets

  protected

  # Create the tickets associated with this batch.
  def create_tickets
    for email in self.emails.split(/\s+/).map(&:strip)
      self.tickets << Ticket.new(:email => email, :ticket_kind => self.ticket_kind, :batch => self)
    end
  end

  # Validate the associated tickets and add validation errors if needed.
  def validate_tickets
    if self.errors[:tickets]
      self.errors.clear
      for ticket in self.tickets
        next if ticket.valid?
        self.errors.add_to_base("Ticket with address '#{ticket.email}': " + ticket.errors.full_messages.join(', '))
      end
    end
  end
end
