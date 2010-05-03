class AddSubjectToTicketKind < ActiveRecord::Migration
  def self.up
    add_column :ticket_kinds, :subject, :string
  end

  def self.down
    remove_column :ticket_kinds, :subject
  end
end
