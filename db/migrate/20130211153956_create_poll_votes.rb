class CreatePollVotes < ActiveRecord::Migration
  def change
    create_table :poll_votes do |t|
      t.references :poll
      t.references :user
      t.references :poll_option
      t.string :type

      t.timestamps
    end
  end
end
