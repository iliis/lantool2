class AddWeightToPollVotes < ActiveRecord::Migration
  def change
    add_column :poll_votes, :weight, :integer
  end
end
