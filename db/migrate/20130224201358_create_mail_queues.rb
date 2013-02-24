class CreateMailQueues < ActiveRecord::Migration
  def change
    create_table :mail_queues do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.text :content

      t.timestamps
    end
  end
end
