class Batch < ActiveRecord::Base
  has_many :tickets
  belongs_to :ticket_kind

  validates_presence_of :ticket_kind_id
  validates_presence_of :emails

  after_save :create_tickets!

protected

  # Create the tickets associated with this batch.
  def create_tickets!
    for email in self.emails.split("\n").map(&:strip)
      self.tickets.create!(:email => email, :ticket_kind => self.ticket_kind)
    end
  end
end
