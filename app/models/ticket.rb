class Ticket < ActiveRecord::Base
  belongs_to :batch
  belongs_to :ticket_kind

  named_scope :ordered, :order => 'created_at desc'

  validates_presence_of :batch
  validates_presence_of :ticket_kind
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

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
end
