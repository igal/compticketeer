class CreateTicketKinds < ActiveRecord::Migration
  def self.up
    create_table :ticket_kinds do |t|
      t.string :title
      t.string :prefix
      t.text :template

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_kinds
  end
end
