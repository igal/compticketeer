class Ticket < ActiveRecord::Base
  belongs_to :batch
  belongs_to :ticket_kind
end
