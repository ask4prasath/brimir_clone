class AddSenderEmailToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :sender_email, :string
  end
end
