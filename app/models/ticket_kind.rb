class TicketKind < ActiveRecord::Base
  named_scope :ordered, :order => "lower(title) asc"

  has_many :tickets
  
  validates_presence_of :title
  validates_length_of :title, :within => 1..128
  validates_presence_of :prefix
  validates_length_of :prefix, :within => 1..20
  validates_presence_of :template
  validates_length_of :template, :minimum => 1
end
