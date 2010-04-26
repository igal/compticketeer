class ChangeTicketsErrorToText < ActiveRecord::Migration
  def self.up
    change_column :tickets, :error, :text, :limit => 2048
  end

  def self.down
    change_column :tickets, :error, :string
  end
end
