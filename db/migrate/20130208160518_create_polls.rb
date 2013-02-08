class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.references :owner
	  t.references :lan
      t.string :type
      t.datetime :expiration_date

      t.timestamps
    end
    add_index :polls, :owner_id
  end
end
