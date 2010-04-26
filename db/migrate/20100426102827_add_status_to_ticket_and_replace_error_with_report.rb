class AddStatusToTicketAndReplaceErrorWithReport < ActiveRecord::Migration
  def self.up
    add_column :tickets, :status, :string
    rename_column :tickets, :error, :report
    remove_column :tickets, :processed

    Ticket.reset_column_information
    for ticket in Ticket.all
      ticket.update_attribute(:status, "created") unless ticket.status
    end
  end

  def self.down
    remove_column :tickets, :status
    rename_column :tickets, :report, :error
    add_column :tickets, :processed, :boolean
  end
end
