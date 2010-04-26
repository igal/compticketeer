class Ticket < ActiveRecord::Base
  belongs_to :batch
  belongs_to :ticket_kind

  named_scope :ordered, :order => 'created_at desc'

  validates_presence_of :batch
  validates_presence_of :ticket_kind
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

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

end
