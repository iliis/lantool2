class AddErrorToMailQueue < ActiveRecord::Migration
  def change
    add_column :mail_queues, :error, :string
  end
end
