# == Schema Information
# Schema version: 20100426102827
#
# Table name: batches
#
#  id             :integer         not null, primary key
#  created_at     :datetime
#  updated_at     :datetime
#  emails         :text
#  ticket_kind_id :integer
#

class Batch < ActiveRecord::Base
  has_many :tickets, :dependent => :destroy
  belongs_to :ticket_kind

  named_scope :ordered, :order => 'created_at desc'

  validates_presence_of :ticket_kind_id
  validates_presence_of :emails

  before_validation :create_tickets
  after_validation :validate_tickets

  # Process all tickets.
  def process
    for ticket in tickets
      ticket.process
    end
  end

  # Process all tickets asynchronously.
  def process_asynchronously
    spawn { self.process }
  end

  protected

  # Create the tickets associated with this batch.
  def create_tickets
    for email in self.emails.split(/\s+/).map(&:strip)
      if ticket = self.tickets.detect {|ticket| ticket.email == email }
        ticket.update_attributes(:ticket_kind => self.ticket_kind, :batch => self)
      else
        ticket = Ticket.new(:email => email, :ticket_kind => self.ticket_kind, :batch => self)
        self.tickets << ticket
      end
      Ticket.find_all_by_email(email).each do |prev_ticket|
        # TODO how to pass this message to controller/view
        logger.warn "Warning: This email already has a #{prev_ticket.ticket_kind.title.upcase} ticket code, emailed status = #{prev_ticket.status.to_s.upcase}"
      end
    end
  end

  # Validate the associated tickets and add validation errors if needed.
  def validate_tickets
    # NOTE: This strange method is run at the end of validation and replaces
    # the vague "Tickets is invalid" validation error with more useful messages
    # that explain what tickets had what errors.
    if self.errors[:tickets]
      self.errors.instance_variable_get(:@errors).delete('tickets')
      for ticket in self.tickets
        next if ticket.valid?
        self.errors.add_to_base("Ticket with address '#{ticket.email}': " + ticket.errors.full_messages.join(', '))
      end
    end
  end
end
