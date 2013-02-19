class CreatePollOptions < ActiveRecord::Migration
  def change
    create_table :poll_options do |t|
      t.references :poll
      t.string :text

      t.timestamps
    end
  end
end
