class AddEmailsAndTicketKindToBatch < ActiveRecord::Migration
  def self.up
    add_column :batches, :emails, :text
    add_column :batches, :ticket_kind_id, :integer
  end

  def self.down
    remove_column :batches, :emails
    remove_column :batches, :ticket_kind_id
  end
end
