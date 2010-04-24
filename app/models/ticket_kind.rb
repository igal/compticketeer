class TicketKind < ActiveRecord::Base
  named_scope :ordered, :order => "title asc"

  has_many :tickets
end
