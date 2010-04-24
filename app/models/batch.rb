class Batch < ActiveRecord::Base
  has_many :tickets
  belongs_to :ticket_kind

  validates_presence_of :ticket_kind_id
  validates_presence_of :emails
end
