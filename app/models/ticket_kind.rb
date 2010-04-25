class TicketKind < ActiveRecord::Base
  named_scope :ordered, :order => "title asc"

  has_many :tickets

  validates_presence_of :title
  validates_presence_of :prefix
  validates_presence_of :template
end
