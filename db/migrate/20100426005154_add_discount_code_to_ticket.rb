class AddDiscountCodeToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :discount_code, :string
  end

  def self.down
    remove_column :tickets, :discount_code
  end
end
