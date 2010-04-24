class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :ticket_kind_id
      t.integer :batch_id
      t.string :email
      t.boolean :processed
      t.string :error
      t.datetime :processed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
